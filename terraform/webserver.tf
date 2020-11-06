
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id = aws_subnet.i_public.id
  provisioner "remote-exec" {
    inline = [
      "yum install httpd php php-mysql -y",
      "yum update -y",
      "chkconfig httpd on",
      "service httpd start",
      "echo \"<?php phpinfo(); ?>\" > /var/www/html/index.php"
    ]
  }
  tags = {
    Name = "HelloWorld"
  }
}