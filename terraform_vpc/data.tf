data "terraform_remote_state" "vars" {
  backend = local.path_backend

  config = {
    path = local.path_common
  }
}
locals {
  config = ""

  // Common Vars
  base_tags       = merge(
  data.terraform_remote_state.vars.outputs.base_tags,
  {
    directory = path.module
  },
  )

  resource_prefix = data.terraform_remote_state.vars.outputs.resource_prefix
  region          = data.terraform_remote_state.vars.outputs.region

  // Paths
  path_common  = "${path.module}/../terraform_common/terraform.tfstate"
  path_backend = "local"
}
