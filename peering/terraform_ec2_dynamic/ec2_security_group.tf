resource "aws_security_group" "ec2_public" {
  for_each = { for k, vpc in local.vpc_ids : k => vpc }

  name   = "${local.resource_prefix}-${each.key}-public-ec2-sg"
  vpc_id = each.value
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }
  ingress {
    from_port   = 3150
    to_port     = 3150
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    local.base_tags,
    {
      Name = "${local.resource_prefix}_dynamic_ec2"
    },
  )
}

resource "aws_security_group" "ec2_private" {
  for_each = { for k, vpc in local.vpc_ids : k => vpc }

  name   = "${local.resource_prefix}-${each.key}-private-ec2-sg"
  vpc_id = each.value
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
