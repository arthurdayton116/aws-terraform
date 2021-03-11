data "terraform_remote_state" "vpc" {
  backend = local.path_backend

  config = {
    path = local.path_vpc
  }
}

data "terraform_remote_state" "s3" {
  backend = local.path_backend

  config = {
    path = local.path_s3
  }
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

data "terraform_remote_state" "vars" {
  backend = local.path_backend

  config = {
    path = local.path_common
  }
}
locals {
  config = ""

  // Common Vars
  base_tags                = data.terraform_remote_state.vars.outputs.base_tags
  resource_prefix          = data.terraform_remote_state.vars.outputs.resource_prefix
  region                   = data.terraform_remote_state.vars.outputs.region
  s3_instance_profile_name = data.terraform_remote_state.s3.outputs.s3_instance_profile_name
  mc_public_ip_id          = data.terraform_remote_state.vpc.outputs.mc_public_ip_id
  mc_private_ip            = data.terraform_remote_state.vpc.outputs.mc_private_ip


  // Paths
  path_vpc     = "${path.module}/../terraform_vpc${local.config}/terraform.tfstate"
  path_common  = "${path.module}/../terraform_common/terraform.tfstate"
  path_s3      = "${path.module}/../terraform_s3/terraform.tfstate"
  path_backend = "local"
}
