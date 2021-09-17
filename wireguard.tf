resource "aws_key_pair" "wireguard_provisioner_key" {
  key_name   = "wireguard-${var.tenant}-${var.domain}-deployer-key"
  public_key = tls_private_key.wireguard_provisioner_key.public_key_openssh

  tags = var.tags
}

resource "tls_private_key" "wireguard_provisioner_key" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "local_file" "wireguard_provisioner_key" {
  content         = tls_private_key.wireguard_provisioner_key.private_key_pem
  filename        = "${path.module}/wireguard_ssh_provisioner_key"
  file_permission = "0600"
}


resource "random_password" "wireguard_password" {
  length  = 16
  special = true
}

module "wireguard" {
  source = "git::https://github.com/mojaloop/iac-shared-modules.git//aws/wg?ref=v1.0.32"

  ami_id                  = var.use_latest_ami ? module.ubuntu-focal-ami.id : var.vpn_ami_list[var.region]
  instance_type           = var.vpn_instance_type
  ssh_key_name            = aws_key_pair.wireguard_provisioner_key.key_name
  subnet_id               = module.public_subnets.named_subnet_ids["management"]["id"]
  tags                    = merge({ Tenant = var.tenant }, var.tags)
  ssh_key                 = tls_private_key.wireguard_provisioner_key.private_key_pem
  ui_admin_pw             = random_password.wireguard_password.result
  vpc_id                  = module.vpc.vpc_id
  cert_domain             = aws_route53_zone.tenant_public.name
  zone_id                 = aws_route53_zone.tenant_public.zone_id
  wireguard_tenancy_name  = var.tenant
}

/* module "wireguard_users" {
  source = "git::https://github.com/mojaloop/iac-shared-modules.git//aws/wg_user?ref=v1.0.32"

  dns_server        = "10.25.0.2"
  wireguard_address = module.wireguard.public_ip
  ssh_key           = tls_private_key.wireguard_provisioner_key.private_key_pem
  id                = 4
} */
