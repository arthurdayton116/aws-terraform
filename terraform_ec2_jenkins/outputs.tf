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

output "jenkins_link" {
  description = "preformed link to public ip of webserver"
  value       = "http://${aws_eip_association.eip_assoc.public_ip}:8080"
}

output "elastic_link" {
  description = "preformed link to public ip of webserver"
  value       = "http://${aws_eip_association.eip_assoc.public_ip}:9200"
}

output "kibana_link" {
  description = "preformed link to public ip of webserver"
  value       = "http://${aws_eip_association.eip_assoc.public_ip}:5601"
}

output "public_ssh_link" {
  description = "preformed command for ssh to public server"
  value       = "ssh -i ~/.ssh/id_rsa_ec2 ubuntu@${aws_eip_association.eip_assoc.public_ip}"
}

output "known_hosts" {
  description="clear hosts"
  value= "rm -R ~/.ssh/known_hosts"
}

output "jenkins_admin_pw" {
  description = "clear hosts"
  value= "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
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
//
//output "curl_local_host" {
//  value = "curl http://localhost"
//}

//output "curl_private_host" {
//  description = "preformed curl for connecting to private server"
//  value       = "curl http://${aws_instance.web2.private_ip}"
//}

