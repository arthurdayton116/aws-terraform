data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}
data "terraform_remote_state" "vars" {
  backend = local.path_backend

  config = {
    path = local.path_common
  }
}

data "terraform_remote_state" "vpc" {
  backend = local.path_backend

  config = {
    path = local.path_vpc
  }
}

locals {
  config = "_${data.terraform_remote_state.vars.outputs.config_mc}"
  //  config=""
  base_tags       = data.terraform_remote_state.vars.outputs["base_tags${local.config}"]
  resource_prefix = data.terraform_remote_state.vars.outputs["resource_prefix${local.config}"]
  region          = data.terraform_remote_state.vars.outputs["region${local.config}"]

  // VPC
  vpc_arn = data.terraform_remote_state.vpc.outputs.vpc_arn
  // Paths
  path_common  = "${path.module}/../../terraform_common/terraform.tfstate"
  path_backend = "local"
  path_vpc     = "${path.module}/../terraform_vpc${local.config}/terraform.tfstate"

}
