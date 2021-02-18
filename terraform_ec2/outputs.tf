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
