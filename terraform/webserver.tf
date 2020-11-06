
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amazon/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"] # Canonical
}


resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id = aws_subnet.i_public.id

  provisioner "local-exec" {
    interpreter = ["/bin/bash" ,"-c"]
    command = "apt-get update; apt-get install apache2;"
  }

  tags = {
    Name = "HelloWorld"
  }
}