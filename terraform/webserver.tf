/* Locally generated public key*/
resource "aws_key_pair" "ec2key" {
  key_name   = "${var.resource_prefix}_publicKey"
  public_key = file(var.public_key_path)
}

/*EC2 instance with web server*/
resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = var.ami_instance_type
  subnet_id              = aws_subnet.subnet_public.id
  vpc_security_group_ids = [aws_security_group.ec2.id]
  key_name               = aws_key_pair.ec2key.key_name

  user_data = var.user_data

  tags = {
    Name = "${var.resource_prefix}_ec2_public"
  }
}

resource "aws_instance" "web2" {
  ami                    = var.ami_id
  instance_type          = var.ami_instance_type
  subnet_id              = aws_subnet.subnet_private.id
  vpc_security_group_ids = [aws_security_group.ec2.id]
  key_name               = aws_key_pair.ec2key.key_name

  user_data = var.user_data

  tags = {
    Name = "${var.resource_prefix}_ec2_private"
  }
}