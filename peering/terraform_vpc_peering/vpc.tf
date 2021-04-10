# Configure the AWS Provider
provider "aws" {
  region = local.region
}

locals {
  vpc_values = {
    a = {
      name      = "${local.resource_prefix}-vpc",
      cidr_vpc  = "10.1.0.0/16",
      region    = local.region
      security_group_ingress_cidr   = ["10.1.0.0/16", "10.2.0.0/16"]
      peer_cidr = "10.2.0.0/16"
    },
    b = {
      name      = "${local.resource_prefix}-vpc",
      cidr_vpc  = "10.2.0.0/16",
      region    = local.region,
      security_group_ingress_cidr   = ["10.1.0.0/16", "10.2.0.0/16"]
      peer_cidr = "10.1.0.0/16"
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

resource "aws_vpc_peering_connection" "a_b" {
  peer_vpc_id = aws_vpc.vpc["a"].id
  vpc_id      = aws_vpc.vpc["b"].id
  auto_accept = true
}