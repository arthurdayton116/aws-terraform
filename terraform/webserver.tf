
//data "aws_ami" "ubuntu" {
//  most_recent = true
//
//  filter {
//    name   = "name"
//    values = ["amazon/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
//  }
//
//  filter {
//    name   = "virtualization-type"
//    values = ["hvm"]
//  }
//
//  owners = ["amazon"] # Canonical
//}


resource "aws_instance" "web" {
  ami           = "ami-07a29e5e945228fa1"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.i_public.id

  user_data     = <<-EOF
                  #!/bin/sh
                  apt-get update
                  apt-get install -y apache2
                  service start apache2
                  chkonfig apache2 on
                  echo "<html><h1>Welcome to Aapache Web Server</h2></html>" > /var/www/html/index.html
                  EOF

  tags = {
    Name = "HelloWorld"
  }
}