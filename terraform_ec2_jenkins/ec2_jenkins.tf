/* Locally generated private key*/
resource "aws_key_pair" "ec2key" {
  key_name   = "${local.resource_prefix}_publicKey"
  public_key = file(var.public_key_path)
}

/*EC2 instance with web server*/
resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = var.ami_instance_type
  subnet_id              = data.terraform_remote_state.vpc.outputs.public_subnet_id
  vpc_security_group_ids = [aws_security_group.ec2_public.id]
  key_name               = aws_key_pair.ec2key.key_name
//  iam_instance_profile   = local.s3_instance_profile_name
  private_ip             = local.jenkins_private_ip

  user_data = var.user_data

  root_block_device {
    volume_size = 30
  }

  provisioner "file" {
    source      = "files/jvm.options"
    destination = "~/jvm.options"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa_ec2")
      host        = self.public_dns
    }
  }

  provisioner "file" {
    source      = "files/kibana.yml"
    destination = "~/kibana.yml"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa_ec2")
      host        = self.public_dns
    }
  }

  provisioner "file" {
    source      = "files/elasticsearch.yml"
    destination = "~/elasticsearch.yml"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa_ec2")
      host        = self.public_dns
    }
  }

  ####### Logstash Files ##########
  ## VVVVVVVVVVVVVVVVVVVVVVVVVVV ##
  provisioner "file" {
    source      = "files/logstash/apache-01.conf"
    destination = "~/apache-01.conf"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa_ec2")
      host        = self.public_dns
    }
  }

  provisioner "file" {
    source      = "files/logstash/apache-daily-access.log"
    destination = "~/apache-daily-access.log"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa_ec2")
      host        = self.public_dns
    }
  }

  provisioner "file" {
    source      = "files/logstash/http.conf"
    destination = "~/http.conf"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa_ec2")
      host        = self.public_dns
    }
  }

  provisioner "file" {
    source      = "files/logstash/jenkins_build.conf"
    destination = "~/jenkins_build_log.conf"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa_ec2")
      host        = self.public_dns
    }
  }

  provisioner "file" {
    source      = "files/logstash/pipelines.yml"
    destination = "~/pipelines.yml"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa_ec2")
      host        = self.public_dns
    }
  }
  ### ^^^^^^^^^^^^^^^^^^^^^^^^^ ###

  ####### Filebeat Files ##########
  ## VVVVVVVVVVVVVVVVVVVVVVVVVVV ##
  provisioner "file" {
    source      = "files/filebeat/filebeat.yml"
    destination = "~/filebeat.yml"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa_ec2")
      host        = self.public_dns
    }
  }
  ### ^^^^^^^^^^^^^^^^^^^^^^^^^ ###

  tags = merge(
    local.base_tags,
    {
      Name = "${local.resource_prefix}_ec2_public"
    },
  )
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.web.id
  allocation_id = local.jenkins_public_ip_id
}

//resource "aws_instance" "web2" {
//  ami                    = var.ami_id
//  instance_type          = var.ami_instance_type
//  subnet_id              = data.terraform_remote_state.vpc.outputs.private_subnet_id
//  vpc_security_group_ids = [aws_security_group.ec2_private.id]
//  key_name               = aws_key_pair.ec2key.key_name
//
//  user_data = var.user_data_private
//
//  tags = merge(
//    local.base_tags,
//    {
//      Name = "${local.resource_prefix}_ec2_private"
//    },
//  )
//}
