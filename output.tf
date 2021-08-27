output "gitlab_server_ip" {
  value       = module.gitlab.server_public_ip
  description = "Public IP of the GitLab server"
}

output "gitlab_hostname" {
  description = "Public hostname of GitLab Server"
  value       = module.gitlab.server_hostname
}

output "gitlab_ci_public_ip" {
  value       = module.gitlab.ci_public_ip
  description = "Public IP of the Gitlab CI runner"
}

output "gitlab_ci_private_ip" {
  value       = module.gitlab.ci_private_ip
  description = "Private IP of the Gitlab CI runner"
}

output "gitlab_ssh_private_key" {
  description = "Private SSH key for GitLab Server and CI runner"
  value       = module.gitlab.gitlab_ssh_private_key
}

output "gitlab_root_pw" {
  description = "root pw for gitlab"
  value       = module.gitlab.gitlab_root_pw
}

output "gitlab_ssh_public_key" {
  description = "Public SSH key for GitLab Server and CI runner"
  value       = module.gitlab.gitlab_ssh_public_key
}

output "domain" {
  value       = var.domain
  description = "Base domain used for this tenant"
}

output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "VPC ID used as base for this tenant"
}

output "public_subnet_ids" {
  description = "Ids of public subnets"
  value       = module.public_subnets.named_subnet_ids
}

output "private_subnet_ids" {
  description = " Ids of private subnets"
  value       = module.private_subnets.named_subnet_ids
}

output "default_security_group_id" {
  description = "Default SG of created VPC"
  value       = module.vpc.vpc_default_security_group_id
}

output "igw_id" {
  description = "Internet Gateway ID"
  value       = module.vpc.igw_id
}

output "private_zone_id" {
  description = "Id of private DNS zone"
  value       = aws_route53_zone.tenant_private.zone_id
}

output "private_zone_name" {
  description = "Private DNS zone. Takes the form of $${var.tenant}.$${var.domain}.internal"
  value       = aws_route53_zone.tenant_private.name
}

output "public_zone_id" {
  description = "Id of public DNS zone"
  value       = aws_route53_zone.tenant_public.zone_id
}

output "public_zone_name" {
  description = "Public DNS zone"
  value       = aws_route53_zone.tenant_public.name
}

output "main_zone_id" {
  description = "Id of var.domain"
  value       = aws_route53_zone.tenant_public.zone_id
}

output "public_subnets_ngw_id" {
  description = "Network Gateway ID"
  value       = module.public_subnets.ngw_id
}

output "public_subnets" {
  description = "Full access to the public subnet objects"
  value       = module.public_subnets
}

output "private_subnets" {
  description = "Full access to the private subnet objects"
  value       = module.private_subnets
}
#nexus outputs
output "nexus_ssh_private_key" {
  description = "Private SSH key for Nexus Server"
  value       = module.nexus.nexus_ssh_private_key
  sensitive   = true
}

output "nexus_ssh_public_key" {
  description = "Public SSH key for Nexus Server"
  value       = module.nexus.nexus_ssh_public_key
}

output "nexus_admin_pw" {
  description = "nexus admin password"
  value       = module.nexus.nexus_admin_pw
  sensitive   = true
}

output "nexus_fqdn" {
  description = "FQDN for for Nexus Server"
  value       = module.nexus.server_hostname
}

output "nexus_docker_repo_listening_port" {
  description = "FQDN for for Nexus Server"
  value       = var.nexus_docker_repo_listening_port
}

output "wireguard_ssh_key_path" {
  value = "${path.module}/wireguard_ssh_provisioner_key"
}

output "wireguard_public_ip" {
  value = module.wireguard.public_ip
}

output "wireguard_private_ip" {
  value = module.wireguard.private_ip
}

output "wireguard_vpn_hostname" {
  value       = module.dns_wireguard.hostname
  description = "Public Wireguard hostname"
}
