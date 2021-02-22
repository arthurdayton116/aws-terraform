output "key_name" {
  value = aws_key_pair.ec2key.key_name
}

output "key_id" {
  value = aws_key_pair.ec2key.id
}

output "webserver_ip" {
  value = aws_instance.web.public_ip
}

output "webserver_link" {
  value = "http://${aws_instance.web.public_ip}"
}

output "public_ssh_link" {
  value = "ssh -i ~/.ssh/id_rsa_ec2 ubuntu@${aws_instance.web.public_ip}"
}

output "copy_private_key_to_ec2" {
  value = "scp -i ~/.ssh/id_rsa_ec2 ~/.ssh/id_rsa_ec2 ubuntu@${aws_instance.web.public_ip}:~/.ssh/id_rsa_ec2"
}

output "private_ssh_link" {
  value = "ssh -i ~/.ssh/id_rsa_ec2 ubuntu@${aws_instance.web2.private_ip}"
}
