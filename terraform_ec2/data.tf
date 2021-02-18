data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "${path.module}/../terraform_vpc/terraform.tfstate"
  }
}
