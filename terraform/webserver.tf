
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
  owners = ["amazon"]
}


resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = "t3.micro"
  subnet_id = aws_subnet.i_public.id

  provisioner "local-exec" {
    command = "sudo yum install httpd php php-mysql -y; sudo yum update -y; sudo chkconfig httpd on; sudo service httpd start; echo \"<?php phpinfo(); ?>\" > /var/www/html/index.php"
  }

  tags = {
    Name = "HelloWorld"
  }
}