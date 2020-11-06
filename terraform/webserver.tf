
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
    command = "sudo -s; yum update -y; yum install httpd -y; chkconfig httpd on; service httpd start; echo \"<h1>Testy</h1>\" > /var/www/html/index.html"
  }

  tags = {
    Name = "HelloWorld"
  }
}