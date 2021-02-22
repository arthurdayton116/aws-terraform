## Create main route table
resource "aws_default_route_table" "main" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.i.id
  }

  tags = merge(
    var.base_tags,
    {
      Name = "${var.resource_prefix}-main-rt"
    },
  )
}

## Create route table
resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(
    var.base_tags,
    {
      Name = "${var.resource_prefix}-rt"
    },
  )
}

## Associate route tables with subnets
resource "aws_route_table_association" "rta_subnet_private" {
  subnet_id      = aws_subnet.subnet_private.id
  route_table_id = aws_default_route_table.main.id
}

resource "aws_route_table_association" "rta_subnet_public" {
  subnet_id      = aws_subnet.subnet_public.id
  route_table_id = aws_route_table.rtb_public.id
}
