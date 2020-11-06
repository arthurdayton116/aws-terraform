
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

  provisioner "local-exec" {
    interpreter = ["/bin/bash" ,"-c"]
    command = <<-EOT
    exec "yum install httpd php php-mysql -y"
    exec "yum update -y"
    exec "chkconfig httpd on"
    exec "service httpd start"
    exec "echo \"<?php phpinfo(); ?>\" > /var/www/html/index.php"
  EOT
  }

  tags = {
    Name = "HelloWorld"
  }
}