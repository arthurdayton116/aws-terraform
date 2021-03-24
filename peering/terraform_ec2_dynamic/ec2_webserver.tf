/* Locally generated private key*/
resource "aws_key_pair" "ec2key" {
  key_name   = "${local.resource_prefix}_publicKey"
  public_key = file(var.public_key_path)
}

/*EC2 instance with web server*/
resource "aws_instance" "public" {
  for_each = { for k, subnet in local.subnet_info : k =>
  subnet if subnet.public == "true" }

  ami                    = var.ami_id
  instance_type          = var.ami_instance_type
  subnet_id              = local.subnet_ids[each.key]
  vpc_security_group_ids = [aws_security_group.ec2_public[each.value.vpc_key].id]
  key_name               = aws_key_pair.ec2key.key_name
  iam_instance_profile   = local.s3_instance_profile_name
  //  private_ip             = local.mc_private_ip

  user_data = var.user_data

  provisioner "file" {
    source      = var.react_path
    destination = "/tmp"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = self.public_dns
    }
  }

  provisioner "file" {
    source      = var.go_api_path
    destination = "/tmp"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = self.public_dns
    }
  }

  provisioner "file" {
    source      = "goapi@.service"
    destination = "~/goapi@.service"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = self.public_dns
    }
  }

  provisioner "file" {
    source      = "dockerStart.sh"
    destination = "~/dockerStart.sh"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = self.public_dns
    }
  }

  //  provisioner "remote-exec" {
  //    inline = [
  //      "sudo echo \"PRIVATE_IP=${self.private_ip}\" >> /etc/environment",
  //      "sudo echo \"PRIVATE_DNS=${self.private_dns}\" >> /etc/environment",
  //      "sudo echo \"SECURITY_GROUP=${self.security_groups}\" >> /etc/environment",
  //      "sudo echo \"AVAILABILITY_ZONE=${self.availability_zone}\" >> /etc/environment",
  //      "sudo echo \"SWAGGER_HOST=${self.public_ip}:3150\" >> /etc/environment",
  //      "sudo echo \"INSTANCE_ID=${self.id}\" >> /etc/environment",
  //      "sudo echo \"PUBLIC_IP=${self.public_ip}\" >> /etc/environment",
  //      "sudo echo \"INSTANCE_TYPE=${self.instance_type}\" >> /etc/environment",
  //      "sudo echo \"SECURITY_GROUPS=${self.security_groups}\" >> /etc/environment",
  //    ]
  //  }

  tags = merge(
    local.base_tags,
    {
      Name = "${local.resource_prefix}-${each.key}-ec2_public"
    },
  )
}




//resource "aws_eip_association" "eip_assoc" {
//  instance_id   = aws_instance.public.id
//  allocation_id = local.mc_public_ip_id
//}

//resource "aws_instance" "private" {
//  for_each = {for k, subnet in local.subnet_info : k =>
//  subnet if subnet.public == "false" }
//
//  ami                    = var.ami_id
//  instance_type          = var.ami_instance_type
//  subnet_id              = local.subnet_ids[each.key]
//  vpc_security_group_ids = [aws_security_group.ec2_public[each.value.vpc_key].id]
//  key_name               = aws_key_pair.ec2key.key_name
//  private_ip = each.value.private_ip
//
//  user_data = var.user_data_private
//
//  provisioner "file" {
//    source      = "nodeapi@.service"
//    destination = "~/nodeapi@.service"
//
//    connection {
//      type        = "ssh"
//      user        = "ubuntu"
//      private_key = file(var.private_key_path)
//      host        = self.public_dns
//    }
//  }
//
//  provisioner "file" {
//    content = <<-EOF
//                        REACT_APP_APIHOSTPORT=${each.value.api_ip}:8080"
//                        PRIVATE_IP=${self.private_ip}
//                        PRIVATE_DNS=${self.private_dns}
//                        SECURITY_GROUP=${self.security_groups}
//                        AVAILABILTY_ZONE=${self.availability_zone}
//                        EOF
//    destination = "/tmp/env_vars"
//
//    connection {
//      type        = "ssh"
//      user        = "ubuntu"
//      private_key = file(var.private_key_path)
//      host        = self.public_dns
//    }
//  }
//
//  provisioner "file" {
//    source      = "~/Desktop/arthurProjects/simpleReactWithApi/apps/api"
//    destination = "/tmp"
//
//    connection {
//      type        = "ssh"
//      user        = "ubuntu"
//      private_key = file(var.private_key_path)
//      host        = self.public_dns
//    }
//  }
//
//  tags = merge(
//    local.base_tags,
//    {
//      Name = "${local.resource_prefix}-${each.key}-ec2_private"
//    },
//  )
//}
