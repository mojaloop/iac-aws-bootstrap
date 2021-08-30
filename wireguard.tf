module "dns_wireguard" {
  source  = "git::https://github.com/cloudposse/terraform-aws-route53-cluster-hostname.git?ref=tags/0.10.0"
  name    = "wireguard"
  zone_id = aws_route53_zone.tenant_public.zone_id
  ttl     = 300
  type    = "A"
  records = [module.wireguard.public_ip]
}

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

resource "aws_security_group" "vpn_sg" {
  vpc_id      = module.vpc.vpc_id
  name        = "${var.tenant}-vpn-host"
  description = "Allow all to vpn host"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "-1"
    to_port     = "-1"
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({}, var.tags)
}

resource "random_password" "wireguard_password" {
  length  = 16
  special = true
}

module "wireguard" {
  source = "git::https://github.com/mojaloop/iac-shared-modules.git//aws/wg?ref=v1.0.15"

  ami_id                  = var.use_latest_ami ? module.ubuntu-focal-ami.id : var.vpn_ami_list[var.region]
  instance_type           = var.vpn_instance_type
  ssh_key_name            = aws_key_pair.wireguard_provisioner_key.key_name
  security_groups         = [aws_security_group.vpn_sg.id]
  subnet_id               = module.public_subnets.named_subnet_ids["management"]["id"]
  tags                    = merge({ Tenant = var.tenant }, var.tags)
  ssh_key                 = tls_private_key.wireguard_provisioner_key.private_key_pem
  ui_admin_pw             = random_password.wireguard_password.result
}

/* module "wireguard_users" {
  source = "git::https://github.com/mojaloop/iac-shared-modules.git//aws/wg_user?ref=v1.0.15"

  dns_server        = "10.25.0.2"
  wireguard_address = module.wireguard.public_ip
  ssh_key           = tls_private_key.wireguard_provisioner_key.private_key_pem
  id                = 4
} */
