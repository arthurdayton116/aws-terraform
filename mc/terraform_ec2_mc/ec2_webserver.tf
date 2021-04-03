/* Locally generated private key*/
resource "aws_key_pair" "ec2key" {
  key_name   = "${local.resource_prefix}_publicKey"
  public_key = file(var.public_key_path)
}

/*EC2 instance with web server*/
resource "aws_instance" "public" {
  ami                    = var.ami_id
  instance_type          = var.ami_instance_type
  subnet_id              = data.terraform_remote_state.vpc.outputs.public_subnet_id
  vpc_security_group_ids = [aws_security_group.ec2_public.id]
  key_name               = aws_key_pair.ec2key.key_name
  iam_instance_profile   = local.s3_instance_profile_name
  private_ip             = local.mc_private_ip

  user_data = local.user_data.default

  provisioner "file" {
    source      = "minecraft@.service"
    destination = "~/minecraft@.service"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = self.public_dns
    }
  }

  provisioner "file" {
    source      = "mc_16_4_server.jar"
    destination = "~/mc_16_4_server.jar"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = self.public_dns
    }
  }

  tags = merge(
    local.base_tags,
    {
      Name = "${local.resource_prefix}_ec2_public"
    },
  )
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.public.id
  allocation_id = local.mc_public_ip_id
}
