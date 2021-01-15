module "bootstrap" {
  source = "../.."
  tags = {
    "Origin" = "Managed by Terraform"
    "Tenant" = "acme" # The Tenant name (probably the name of the customer - this should be the same as the 'tenant' below)
  }

  domain       = "acme.com" # The FQDN of the tenant
  tenant       = "acme"             # The Tenant name (probably the name of the customer - this should be the same as ths "tenant" above)
  region       = "eu-west-1"         # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-available-regions
  environments = ["dev"]             # Comma Separated list of environments in this tenant.    e.g. ["dev","qa","test1"]
}

############################################### DO NOT EDIT BELOW THIS LINE #############################################

terraform {
  backend "s3" {
    key = "bootstrap/terraform.tfstate"
  }
}

output "gitlab_ssh_private_key" {
  value       = module.bootstrap.gitlab_ssh_private_key
  description = "SSH key to access GitLab VM"
}

output "domain" {
  value       = module.bootstrap.domain
  description = "Base domain used for this tenant"
}

output "vpc_id" {
  value       = module.bootstrap.vpc_id
  description = "VPC ID used as base for this tenant"
}

output "public_subnet_ids" {
  value = module.bootstrap.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.bootstrap.private_subnet_ids
}

output "private_zone_name" {
  value = module.bootstrap.private_zone_name
}

output "public_zone_id" {
  value = module.bootstrap.public_zone_id
}

output "public_zone_name" {
  value = module.bootstrap.public_zone_name
}

output "gitlab_server_ip" {
  value = module.bootstrap.gitlab_server_ip
}

output "gitlab_ci_public_ip" {
  value = module.bootstrap.gitlab_ci_public_ip
}

output "gitlab_ci_private_ip" {
  value = module.bootstrap.gitlab_ci_private_ip
}

output "wireguard_public_ip" {
  value = module.bootstrap.wireguard_public_ip
}

output "wireguard_private_ip" {
  value = module.bootstrap.wireguard_private_ip
}

output "wireguard_vpn_hostname" {
  value       = module.bootstrap.wireguard_vpn_hostname
  description = "Public Wireguard hostname"
}

output "nexus_admin_pw" {
  description = "nexus admin password"
  value       = module.bootstrap.nexus_admin_pw
  sensitive   = true
}

output "nexus_fqdn" {
  description = "FQDN for for Nexus Server"
  value       = module.bootstrap.nexus_fqdn
}

output "nexus_docker_repo_listening_port" {
  description = "FQDN for for Nexus Server"
  value       = module.bootstrap.nexus_docker_repo_listening_port
}

output "nexus_ssh_public_key" {
  description = "FQDN for for Nexus Server"
  value       = module.bootstrap.nexus_ssh_public_key
}

output "nexus_ssh_private_key" {
  description = "FQDN for for Nexus Server"
  value       = module.bootstrap.nexus_ssh_private_key
  sensitive   = true
}
