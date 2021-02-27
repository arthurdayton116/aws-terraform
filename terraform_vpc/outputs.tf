output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.subnet_public.id
}

output "private_subnet_id" {
  value = aws_subnet.subnet_private.id
}

output "mc_public_ip" {
  value = aws_eip.i.public_ip
}

output "mc_private_ip" {
  value = var.mc_subnet_private_ip
}

output "mc_public_ip_id" {
  value = aws_eip.mc_public_ip.id
}

