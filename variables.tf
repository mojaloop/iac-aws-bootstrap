variable "region" {
  description = "AWS region. (e.g. us-west-1, eu-west-1, ap-south-1)"
  default     = "eu-west-1"
}

variable "gitlab_ami_list" {
  description = "Static list of AMIs per region, for use with Gitlab (Currently pointing to Ubuntu Bionic)"
  type        = map(any)

  default = {
    eu-west-1      = "ami-0701e7be9b2a77600"
    eu-west-3      = "ami-06b026f31a4660491"
    eu-west-2      = "ami-09cb5d36edfe093d3"
    ap-south-1     = "ami-0885d40ec66abfb42"
    ap-southeast-1 = "ami-0f7719e8b7ba25c61"
  }
}

variable "vpn_ami_list" {
  description = "Static list of AMIs per region (Currently pointing to Ubuntu Focal), for use with Wireguard"
  type        = map(any)

  default = {
    af-south-1     = "ami-0852a941175b30c13"
    ap-east-1      = "ami-6d03411c"
    ap-northeast-1 = "ami-09b86f9709b3c33d4"
    ap-northeast-2 = "ami-044057cb1bc4ce527"
    ap-northeast-3 = "ami-0c733c715f0e4ee50"
    ap-south-1     = "ami-0cda377a1b884a1bc"
    ap-southeast-1 = "ami-093da183b859d5a4b"
    ap-southeast-2 = "ami-0f158b0f26f18e619"
    ca-central-1   = "ami-0edab43b6fa892279"
    cn-north-1     = "ami-0bdcf50b6cefb4366"
    cn-northwest-1 = "ami-04effa29f4d91541f"
    eu-central-1   = "ami-0c960b947cbb2dd16"
    eu-north-1     = "ami-008dea09a148cea39"
    eu-south-1     = "ami-01eec6bdfa20f008e"
    eu-west-1      = "ami-06fd8a495a537da8b"
    eu-west-2      = "ami-05c424d59413a2876"
    eu-west-3      = "ami-078db6d55a16afc82"
    me-south-1     = "ami-053a63c3a3f73ca70"
    sa-east-1      = "ami-02dc8ad50da58fffd"
    us-east-1      = "ami-0dba2cb6798deb6d8"
    us-east-2      = "ami-07efac79022b86107"
    us-west-1      = "ami-021809d9177640a20"
    us-west-2      = "ami-06e54d05255faf8f6"
  }
}

variable "vpn_instance_type" {
  description = "ec2 instance type to install openvpn"
  type        = string
  default     = "t2.small"
}

variable "use_latest_ami" {
  description = "Set this to true to pick the latest version available of Ubuntu Focal, otherwise a predefined image (from vpn_ami_list and gitlab_ami_list variable) will be used."
  default     = true
}

variable "cidr_block" {
  description = "Subnet to allocate to the VPC. All tenant resources will have IP addresses assigned from this block. The largest block supported is a /16"
  type        = string
  default     = "10.25.0.0/16"
}

variable "environments" {
  description = "List of environments for the tenatn. Each environment will contain an instance of Mojaloop and associated services."
  type        = list(string)
  default     = ["dev"]
}

variable "public_subnets" {
  default     = ["gateway", "management", "simulators"]
  type        = list(string)
  description = "List of public subnets used by a Mojaloop environment. This should not need changing from the default unless a tenant is using a custom design"
}

variable "private_subnets" {
  default     = ["mojaloop", "monitoring", "logs", "wso2", "add-ons", "support-services"]
  type        = list(string)
  description = "List of private subnets used by a Mojaloop environment. This should not need changing from the default unless a tenant is using a custom design"
}

variable "tenant" {
  description = "Tenant name, lower case and without spaces."
  type        = string
}

variable "tags" {
  description = "Contains detault tags for this project"
}

variable "domain" {
  description = "Base domain to attach the tenant to."
  type        = string
}

variable "nexus_docker_repo_listening_port" {
  type    = number
  default = 8082
}

variable "nexus_admin_password" {
  type        = string
  description = "nexus admin password"
  default     = ""
}

variable "nexus_instance_type" {
  type        = string
  description = "nexus instance type"
  default     = "t3.medium"
}

variable "nexus_ami_list" {
  description = "Static list of AMIs per region, for use with Gitlab (Currently pointing to Ubuntu Bionic)"
  type        = map(any)

  default = {
    eu-west-1      = "ami-0701e7be9b2a77600"
    eu-west-3      = "ami-06b026f31a4660491"
    eu-west-2      = "ami-09cb5d36edfe093d3"
    ap-south-1     = "ami-0885d40ec66abfb42"
    ap-southeast-1 = "ami-0f7719e8b7ba25c61"
  }
}

variable "gitlab_use_staging_letsencrypt" {
  description = "use staging instead of prod letsencrypt"
  default     = false
  type        = bool
}

variable "iac_group_name" {
  type        = string
  description = "iac group name"
  default     = "admin"
}

variable "days_retain_gitlab_snapshot" {
  type        = number
  description = "number of days to retain gitlab snapshots"
  default     = 7
}
variable "enable_github_oauth" {
  type = bool
  description = "enable auth from github oauth app"
  default = false
}

variable "github_oauth_id" {
  type        = string
  description = "github oauth id"
  default = ""
}

variable "github_oauth_secret" {
  type        = string
  description = "github oauth secret"
  default = ""
  sensitive = true
}

variable "gitlab_rbac_groups" {
  type        = list(string)
  description = "groups to seed in gitlab for rbac"
  default = ["tenant-admins", "tenant-viewers"]
}

variable "smtp_server_enable" {
  type = bool
  description = "enable smtp server (ses)"
  default = false
}

variable "gitlab_version" {
  type        = string
  description = "gitlab_version"
  default = "14.8.2-ee.0"
}