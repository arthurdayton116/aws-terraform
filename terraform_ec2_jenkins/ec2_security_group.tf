resource "aws_security_group" "ec2_public" {
  name   = "${local.resource_prefix}_ec2"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
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
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }
  ingress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }
  ingress {
    from_port   = 5601
    to_port     = 5601
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
      Name = "${local.resource_prefix}_ec2"
    },
  )
}

//resource "aws_security_group" "ec2_private" {
//  name   = "${local.resource_prefix}_ec2_private"
//  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
//  ingress {
//    from_port   = 22
//    to_port     = 22
//    protocol    = "tcp"
//    cidr_blocks = ["${local.jenkins_private_ip}/32"]
//  }
//  ingress {
//    from_port   = 80
//    to_port     = 80
//    protocol    = "tcp"
//    cidr_blocks = ["${local.jenkins_private_ip}/32"]
//  }
//  egress {
//    from_port   = 0
//    to_port     = 0
//    protocol    = "-1"
//    cidr_blocks = ["0.0.0.0/0"]
//  }
//}
