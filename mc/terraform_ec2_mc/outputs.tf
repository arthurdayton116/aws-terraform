output "key_name" {
  description = "the key pair you are using"
  value       = aws_key_pair.ec2key.key_name
}

output "key_id" {
  value = aws_key_pair.ec2key.id
}

output "webserver_ip" {
  description = "The public ip of webserver"
  value       = aws_eip_association.eip_assoc.public_ip
}

output "webserver_tags" {
  description = "The public ip of webserver"
  value       = aws_instance.public.tags
}

output "webserver_link" {
  description = "preformed link to public ip of webserver"
  value       = "http://${aws_eip_association.eip_assoc.public_ip}"
}

output "public_ssh_link" {
  description = "preformed command for ssh to public server"
  value       = "ssh -i ~/.ssh/id_rsa_ec2 ubuntu@${aws_eip_association.eip_assoc.public_ip}"
}

output "copy_private_key_to_ec2" {
  description = "preformed scp command for copying private key to webserver"
  value       = "scp -i ~/.ssh/id_rsa_ec2 ~/.ssh/id_rsa_ec2 ubuntu@${aws_eip_association.eip_assoc.public_ip}:~/.ssh/id_rsa_ec2"
}

output "curl_local_host" {
  value = "curl http://localhost"
}

output "path_vpc" {
  value = local.path_vpc
}
