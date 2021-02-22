resource "aws_nat_gateway" "i" {
  allocation_id = aws_eip.i.id
  subnet_id     = aws_subnet.subnet_public.id

  tags = merge(
    var.base_tags,
    {
      Name = "${var.resource_prefix}-natgw"
    },
  )
}

resource "aws_eip" "i" {
  vpc = true
  tags = merge(
    var.base_tags,
    {
      Name = "${var.resource_prefix}-eip"
    },
  )
}
