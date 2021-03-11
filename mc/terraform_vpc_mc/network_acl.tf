resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.vpc.default_network_acl_id
  subnet_ids             = [aws_subnet.subnet_public.id]
  // EGRESS
  egress {
    protocol   = -1
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  egress {
    protocol   = "tcp"
    rule_no    = 210
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  egress {
    protocol   = "tcp"
    rule_no    = 220
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }
  //  egress {
  //    protocol   = "tcp"
  //    rule_no    = 300
  //    action     = "allow"
  //    cidr_block = "0.0.0.0/0"
  //    from_port  = 25567
  //    to_port    = 25567
  //  }
  // INGRESS
  ingress {
    protocol   = -1
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  //  ingress {
  //    protocol   = "tcp"
  //    rule_no    = 215
  //    action     = "allow"
  //    cidr_block = "${chomp(data.http.myip.body)}/32"
  //    from_port  = 80
  //    to_port    = 80
  //  }
  //  ingress {
  //    protocol   = "tcp"
  //    rule_no    = 230
  //    action     = "allow"
  //    cidr_block = "${chomp(data.http.myip.body)}/32"
  //    from_port  = 25567
  //    to_port    = 25567
  //  }
  //  ingress {
  //    protocol   = "tcp"
  //    rule_no    = 300
  //    action     = "allow"
  //    cidr_block = "${chomp(data.http.myip.body)}/32"
  //    from_port  = 22
  //    to_port    = 22
  //  }

  tags = merge(
    local.base_tags,
    {
      Name   = "${local.resource_prefix}-network-acl"
      Access = "public"
    },
  )
}
