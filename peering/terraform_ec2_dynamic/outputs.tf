output "key_name" {
  description = "the key pair you are using"
  value       = aws_key_pair.ec2key.key_name
}

output "key_id" {
  value = aws_key_pair.ec2key.id
}

output "webserver_ips" {
  value = {
    for k, ec2 in aws_instance.public :
    k => ec2.public_ip
  }

  description = "The public ip of webserver"
}

output "webserver_privateips" {
  value = {
  for k, ec2 in aws_instance.public :
  k => ec2.private_ip
  }

  description = "The private ip of webserver"
}

output "webserver_link" {
  value = {
    for k, ec2 in aws_instance.public :
    k => "http://${ec2.public_ip}"
  }

  description = "preformed link to public ip of webserver"
}

output "public_ssh_link" {
  value = {
    for k, ec2 in aws_instance.public :
    k => "ssh -i ~/.ssh/id_rsa_ec2 ubuntu@${ec2.public_ip}"
  }

  description = "preformed command for ssh to public server"
  //  value       = "ssh -i ~/.ssh/id_rsa_ec2 ubuntu@${each.value.eip_assoc.public_ip}"
}

//output "copy_private_key_to_ec2" {
//  description = "preformed scp command for copying private key to webserver"
//  value       = "scp -i ~/.ssh/id_rsa_ec2 ~/.ssh/id_rsa_ec2 ubuntu@${aws_eip_association.eip_assoc.public_ip}:~/.ssh/id_rsa_ec2"
//}
//
//output "private_ssh_link" {
//  description = "preformed ssh command for connecting to private server"
//  value       = "ssh -i ~/.ssh/id_rsa_ec2 ubuntu@${aws_instance.web2.private_ip}"
//}

//output "curl_local_host" {
//  value = "curl http://localhost"
//}
//
//output "curl_private_host" {
//  description = "preformed curl for connecting to private server"
//  value       = "curl http://${aws_instance.web2.private_ip}"
//}
