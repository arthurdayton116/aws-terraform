data "terraform_remote_state" "vars" {
  backend = local.path_backend

  config = {
    path = local.path_common
  }
}
locals {
  config = ""
  // Split path into directories
  dir_path_array = split("/", path.cwd)
  // get length of resulting array
  dpl = length(local.dir_path_array)
  // put it back together with last two dirs (non zero index array)
  dir_path_tag = join("/", slice(local.dir_path_array, local.dpl - 2, local.dpl))

  // Common Vars
  base_tags = merge(
    data.terraform_remote_state.vars.outputs.base_tags,
    {
      directory = local.dir_path_tag
    },
  )
  resource_prefix = data.terraform_remote_state.vars.outputs.resource_prefix
  region          = "us-east-1"

  // Paths
  path_common    = "${path.module}/../terraform_common/terraform.tfstate"
  path_backend   = "local"
  path_directory = path.module
}
