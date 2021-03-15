# Configure the AWS Provider
provider "aws" {
  region = local.region
}

locals {
  vpc_values = {
    a = {
      name     = "${local.resource_prefix}-vpc",
      cidr_vpc = "10.1.0.0/16",
      region   = local.region
    },
    b = {
      name     = "${local.resource_prefix}-vpc",
      cidr_vpc = "10.2.0.0/16",
      region   = local.region
    },
  }
}



## Create vpc
resource "aws_vpc" "vpc" {
  for_each             = local.vpc_values
  cidr_block           = each.value.cidr_vpc
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    local.base_tags,
    {
      Name = "${each.value.name}-${each.key}"
    },
  )
}

## Create internet gateway
resource "aws_internet_gateway" "i" {
  for_each = aws_vpc.vpc
  vpc_id   = each.value.id
  tags = merge(
    local.base_tags,
    {
      Name = "${local.resource_prefix}-vpc${each.key}-igw"
    },
  )
}
