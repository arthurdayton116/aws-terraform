
data "aws_ami" "amazon-linux-2" {
  most_recent = true


  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
  owners = []
}


resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = "t3.micro"
  subnet_id = aws_subnet.i_public.id

  provisioner "local-exec" {
    interpreter = ["/bin/bash" ,"-c"]
    command = "yum install httpd php php-mysql -y; yum update -y; chkconfig httpd on; service httpd start; echo \"<?php phpinfo(); ?>\" > /var/www/html/index.php"
  }

  tags = {
    Name = "HelloWorld"
  }
}