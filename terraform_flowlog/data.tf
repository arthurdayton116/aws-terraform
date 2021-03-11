data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = local.path_vpc
  }
}

data "terraform_remote_state" "vars" {
  backend = "local"

  config = {
    path = local.path_common
  }
}

locals {
  config = "_${data.terraform_remote_state.vars.outputs.config_mc}"
  //  config=""

  // Common Vars
  base_tags       = data.terraform_remote_state.vars.outputs["base_tags${local.config}"]
  resource_prefix = data.terraform_remote_state.vars.outputs["resource_prefix${local.config}"]
  region          = data.terraform_remote_state.vars.outputs["region${local.config}"]

  // VPC
  vpc_id          = data.terraform_remote_state.vpc.outputs["vpc_id"]

  // Paths
  path_vpc        = "${path.module}/../mc/terraform_vpc_mc/terraform.tfstate"
  path_common     = "${path.module}/../terraform_common/terraform.tfstate"
}
