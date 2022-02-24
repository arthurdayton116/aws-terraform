output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_arn" {
  value = aws_vpc.vpc.arn
}

output "public_subnet_id" {
  value = aws_subnet.subnet_public.id
}

//output "private_subnet_id" {
//  value = aws_subnet.subnet_private.id
//}

output "jenkins_public_ip" {
  value = aws_eip.jenkins_public_ip.public_ip
}

output "jenkins_private_ip" {
  value = var.jenkins_subnet_private_ip
}

output "jenkins_public_ip_id" {
  value = aws_eip.jenkins_public_ip.id
}

output "base_tags" {
  value = var.base_tags
}

output "resource_prefix" {
  value = var.resource_prefix
}

output "region" {
  value = var.region
}


