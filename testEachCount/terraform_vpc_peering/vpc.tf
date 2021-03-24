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



## Create vpc for each
resource "aws_vpc" "vpc_each" {
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

## Create vpc count
resource "aws_vpc" "vpc_count" {
  count             = 2
  cidr_block           = "10.${count.index}.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
  local.base_tags,
  {
    Name = "vpc-${count.index}"
  },
  )
}

## Create internet gateway
resource "aws_internet_gateway" "i" {
  for_each = aws_vpc.vpc_each
  vpc_id   = each.value.id
  tags = merge(
    local.base_tags,
    {
      Name = "${local.resource_prefix}-vpc${each.key}-igw"
    },
  )
}
