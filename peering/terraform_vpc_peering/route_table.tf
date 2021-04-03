## Create main route table
resource "aws_default_route_table" "main" {
  for_each               = local.vpc_values
  default_route_table_id = aws_vpc.vpc[each.key].default_route_table_id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.i["${each.key}_a"].id
  }

  tags = merge(
    local.base_tags,
    {
      Name = "${local.resource_prefix}-vpc-${each.key}-main-rt"
    },
  )
}

## Create route table
resource "aws_route_table" "i_public" {
  for_each = local.vpc_values
  vpc_id   = aws_vpc.vpc[each.key].id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.i[each.key].id
  }


  route {
    cidr_block                = each.value.peer_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.a_b.id
  }

  tags = merge(
    local.base_tags,
    {
      Name = "${local.resource_prefix}-vpc-${each.key}-rt"
    },
  )
}

## Associate route tables with subnets
resource "aws_route_table_association" "i_subnet_private" {
  for_each = { for k, subnet in local.subnets : k =>
  subnet if subnet.public == "false" }
  subnet_id      = aws_subnet.i[each.key].id
  route_table_id = aws_default_route_table.main[each.value.vpc_key].id
}

resource "aws_route_table_association" "i_subnet_public" {
  for_each = { for k, subnet in local.subnets : k =>
  subnet if subnet.public == "true" }
  subnet_id      = aws_subnet.i[each.key].id
  route_table_id = aws_route_table.i_public[each.value.vpc_key].id
}
