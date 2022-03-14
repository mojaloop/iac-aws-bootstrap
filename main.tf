locals {
  all_pub_subnets  = merge({"management" = data.aws_availability_zones.available.names[0]}, {for pair in setproduct(var.environments, data.aws_availability_zones.available.names) : "${pair[0]}-${pair[1]}" => pair[1]})
  all_priv_subnets = {for pair in setproduct(var.environments, data.aws_availability_zones.available.names) : "${pair[0]}-${pair[1]}" => pair[1]}
}

module "ubuntu-bionic-ami" {
  source  = "git::https://github.com/mojaloop/iac-shared-modules.git//aws/ami-ubuntu?ref=v1.0.45"
  release = "18.04"
}

module "ubuntu-focal-ami" {
  source  = "git::https://github.com/mojaloop/iac-shared-modules.git//aws/ami-ubuntu?ref=v1.0.45"
  release = "20.04"
}

module "vpc" {
  source     = "github.com/cloudposse/terraform-aws-vpc.git?ref=0.18.1"
  namespace  = var.tenant
  name       = "vpc"
  cidr_block = var.cidr_block
  tags       = merge({}, var.tags)
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "public_subnets" {
  source            = "./modules/named-subnets"
  namespace         = var.tenant
  name              = var.tenant
  subnet_az_map      = local.all_pub_subnets
  vpc_id            = module.vpc.vpc_id
  cidr_block        = cidrsubnet(var.cidr_block, 1, 0)
  max_subnets       = 128
  type              = "public"
  igw_id            = module.vpc.igw_id
  tags              = merge({}, var.tags)
}

module "private_subnets" {
  source            = "./modules/named-subnets"
  namespace         = var.tenant
  name              = var.tenant
  subnet_az_map      = local.all_priv_subnets
  vpc_id            = module.vpc.vpc_id
  cidr_block        = cidrsubnet(var.cidr_block, 1, 1)
  max_subnets       = 128
  type              = "private"
  ngw_id            = module.public_subnets.ngw_id
  tags              = merge({}, var.tags)
}

module "gitlab" {
  source                  = "git::https://github.com/mojaloop/iac-shared-modules.git//aws/gitlab?ref=v2.1.11"
  ami                     = var.use_latest_ami ? module.ubuntu-focal-ami.id : var.gitlab_ami_list[var.region]
  instance_type           = "t2.large"
  gitlab_runner_size      = "c5.2xlarge"
  domain                  = var.domain
  namespace               = var.tenant
  fqdn                    = "gitlab.${var.tenant}.${var.domain}"
  vpc_id                  = module.vpc.vpc_id
  zone_id                 = aws_route53_zone.tenant_public.zone_id
  security_groups         = []
  subnets                 = [module.public_subnets.named_subnet_ids["management"]["id"]]
  tags                    = merge({}, var.tags)
  user_data               = chomp(file("${path.module}/templates/userdata"))
  use_letsencrypt_staging = var.gitlab_use_staging_letsencrypt
  tenant                  = var.tenant
  enable_github_oauth     = var.enable_github_oauth
  github_oauth_id         = var.github_oauth_id
  github_oauth_secret     = var.github_oauth_secret
  smtp_server_enable      = var.smtp_server_enable
  smtp_server_address     = "email-smtp.${var.region}.amazonaws.com"
  smtp_server_port        = 587
  smtp_server_user        = var.smtp_server_enable ? module.ses[0].access_key_id : "user"
  smtp_server_pw          = var.smtp_server_enable ? module.ses[0].ses_smtp_password : "pass"
  smtp_server_mail_domain = "${lower(var.tenant)}.${var.domain}"
  gitlab_version          = var.gitlab_version
}

module "nexus" {
  source                     = "git::https://github.com/mojaloop/iac-shared-modules.git//aws/nexus?ref=v2.1.11"
  ami                        = var.use_latest_ami ? module.ubuntu-focal-ami.id : var.nexus_ami_list[var.region]
  instance_type              = var.nexus_instance_type
  domain                     = var.domain
  namespace                  = var.tenant
  vpc_id                     = module.vpc.vpc_id
  zone_id                    = aws_route53_zone.tenant_public.zone_id
  security_groups            = []
  subnets                    = [module.public_subnets.named_subnet_ids["management"]["id"]]
  tags                       = merge({}, var.tags)
  nexus_admin_password       = var.nexus_admin_password
  docker_repo_listening_port = var.nexus_docker_repo_listening_port
  tenant                     = var.tenant
}

module "ses" {
  count = var.smtp_server_enable ? 1 : 0
  source  = "cloudposse/ses/aws"
  version = "~> 0.22.0"

  domain                 = "${lower(var.tenant)}.${var.domain}"
  iam_access_key_max_age = 0
  name                   = "tenant-${var.tenant}-ses"
  ses_group_enabled      = false
  ses_user_enabled       = true
  verify_dkim            = true
  verify_domain          = true
  zone_id                = aws_route53_zone.tenant_public.id

  tags              = merge({}, var.tags)
}