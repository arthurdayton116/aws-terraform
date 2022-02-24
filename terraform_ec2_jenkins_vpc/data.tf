//data "terraform_remote_state" "vars" {
//  backend = local.path_backend
//
//  config = {
//    path = local.path_common
//  }
//}
locals {
  config = ""

  // Common Vars
  base_tags       = merge(
  var.base_tags,
  )

  resource_prefix = var.resource_prefix
  region          = var.region

  // Paths
  path_common  = "${path.module}/../terraform_common/terraform.tfstate"
  path_backend = "local"
}
