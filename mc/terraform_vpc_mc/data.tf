data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}
data "terraform_remote_state" "vars" {
  backend = local.path_common

  config = {
    path = local.path_common
  }
}
locals {
  config = "_${data.terraform_remote_state.vars.outputs.config_mc}"
  //  config=""
  base_tags       = data.terraform_remote_state.vars.outputs["base_tags${local.config}"]
  resource_prefix = data.terraform_remote_state.vars.outputs["resource_prefix${local.config}"]
  region          = data.terraform_remote_state.vars.outputs["region${local.config}"]

  // Paths
  path_common  = "${path.module}/../../terraform_common/terraform.tfstate"
  path_backend = "local"
}