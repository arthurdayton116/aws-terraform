locals {
  subnets = {
    a_a = {
      vpc_key     = "a",
      zone        = "${local.region}a",
      cidr_block  = "10.1.0.0/19"
      public      = "true"
      nat_gateway = "true"
      api_ip      = "10.1.96.10"
    },
    a_b = {
      vpc_key     = "a",
      zone        = "${local.region}b",
      cidr_block  = "10.1.32.0/19"
      public      = "true"
      nat_gateway = "false"
      api_ip      = "10.1.128.10"
    },
    a_c = {
      vpc_key     = "a",
      zone        = "${local.region}c",
      cidr_block  = "10.1.64.0/19"
      public      = "true"
      nat_gateway = "false"
      api_ip      = "10.1.160.10"
    },
    a_d = {
      vpc_key     = "a",
      zone        = "${local.region}a",
      cidr_block  = "10.1.96.0/19"
      public      = "false"
      nat_gateway = "false"
      private_ip  = "10.1.96.10"
    },
    a_e = {
      vpc_key     = "a",
      zone        = "${local.region}b",
      cidr_block  = "10.1.128.0/19"
      public      = "false"
      nat_gateway = "false"
      private_ip  = "10.1.128.10"
    },
    a_f = {
      vpc_key     = "a",
      zone        = "${local.region}c",
      cidr_block  = "10.1.160.0/19"
      public      = "false"
      nat_gateway = "false"
      private_ip  = "10.1.160.10"
    },
    b_a = {
      vpc_key     = "b",
      zone        = "${local.region}a",
      cidr_block  = "10.2.0.0/19"
      public      = "true"
      nat_gateway = "true"
      api_ip      = "10.2.96.10"
    },
    b_b = {
      vpc_key     = "b",
      zone        = "${local.region}b",
      cidr_block  = "10.2.32.0/19"
      public      = "true"
      nat_gateway = "false"
      api_ip      = "10.2.128.10"
    },
    b_c = {
      vpc_key     = "b",
      zone        = "${local.region}c",
      cidr_block  = "10.2.64.0/19"
      public      = "true"
      nat_gateway = "false"
      api_ip      = "10.2.160.10"
    }
    b_d = {
      vpc_key     = "b",
      zone        = "${local.region}a",
      cidr_block  = "10.2.96.0/19"
      public      = "false"
      nat_gateway = "false"
      private_ip  = "10.2.96.10"
    },
    b_e = {
      vpc_key     = "b",
      zone        = "${local.region}b",
      cidr_block  = "10.2.128.0/19"
      public      = "false"
      nat_gateway = "false"
      private_ip  = "10.2.128.10"
    },
    b_f = {
      vpc_key     = "b",
      zone        = "${local.region}c",
      cidr_block  = "10.2.160.0/19"
      public      = "false"
      nat_gateway = "false"
      private_ip  = "10.2.160.10"
    },
  }
}

resource "aws_subnet" "i" {
  for_each = local.subnets

  vpc_id                  = aws_vpc.vpc[each.value.vpc_key].id
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = each.value.public
  availability_zone       = each.value.zone
  tags = merge(
    local.base_tags,
    {
      Name   = "${local.resource_prefix}-vpc-${each.key}-${each.value.public == "true" ? "public" : "private"}"
      vpc    = "vpc-${each.value.vpc_key}"
      access = each.value.public == "true" ? "public" : "private"
    },
  )
}
