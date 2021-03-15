resource "aws_nat_gateway" "i" {
  for_each = {for k, subnet in local.subnets : k =>
  subnet if subnet.nat_gateway == "true" }

  allocation_id = aws_eip.i[each.key].id
  subnet_id     = aws_subnet.i[each.key].id

  tags = merge(
    local.base_tags,
    {
      Name = "${local.resource_prefix}-natgw"
    },
  )
}

resource "aws_eip" "i" {
  for_each = {for k, subnet in local.subnets : k =>
subnet if subnet.nat_gateway == "true" }

  vpc = true
  tags = merge(
    local.base_tags,
    {
      Name = "${local.resource_prefix}-${each.key}-eip"
    },
  )
}
