module "init-gitlab" {
  source                     = "git::https://github.com/mojaloop/iac-shared-modules.git//gitlab/init-config?ref=v2.1.4"
  iac_user_key_secret        = data.terraform_remote_state.tenant.outputs.iac_user_key_id
  iac_user_key_id            = data.terraform_remote_state.tenant.outputs.iac_user_key_secret
  group_list                 = data.terraform_remote_state.tenant.outputs.gitlab_rbac_groups
  env_list                   = data.terraform_remote_state.tenant.outputs.environments
  root_token                 = data.terraform_remote_state.tenant.outputs.gitlab_root_token
  gitlab_url                 = "https://${data.terraform_remote_state.tenant.outputs.gitlab_hostname}"
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
    region = "eu-west-1"
    bucket = "infra4-mojaloop-state"
    key    = "bootstrap/terraform.tfstate"
  }
}