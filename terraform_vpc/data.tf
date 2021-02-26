data "terraform_remote_state" "vars" {
  backend = "local"

  config = {
    path = "${path.module}/../terraform_common/terraform.tfstate"
  }
}
locals {
  base_tags=data.terraform_remote_state.vars.outputs.base_tags
  resource_prefix=data.terraform_remote_state.vars.outputs.resource_prefix
  region=data.terraform_remote_state.vars.outputs.region
}
