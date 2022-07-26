module "init-gitlab" {
  source                     = "git::https://github.com/mojaloop/iac-shared-modules.git//gitlab/init-config?ref=v2.1.14"
  iac_user_key_secret        = data.terraform_remote_state.tenant.outputs.iac_user_key_secret
  iac_user_key_id            = data.terraform_remote_state.tenant.outputs.iac_user_key_id
  group_list                 = data.terraform_remote_state.tenant.outputs.gitlab_rbac_groups
  env_list                   = data.terraform_remote_state.tenant.outputs.environments
  root_token                 = data.terraform_remote_state.tenant.outputs.gitlab_root_token
  gitlab_url                 = "https://${data.terraform_remote_state.tenant.outputs.gitlab_hostname}"
  two_factor_grace_period    = 0
}


############################################### DO NOT EDIT BELOW THIS LINE #############################################

terraform {
  backend "s3" {
    key = "bootstrap-post-config/terraform.tfstate"
  }
}

data "terraform_remote_state" "tenant" {
  backend = "s3"
  config = {
    region = var.region
    bucket = var.bucket
    key    = "bootstrap/terraform.tfstate"
  }
}

variable "region" {
  description = "region to install in"
  type        = string
}
variable "bucket" {
  description = "bucket name"
  type        = string
}
