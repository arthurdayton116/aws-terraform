output "vpc_ids" {
  value = {
    for k, vpc in aws_vpc.vpc :
    k => vpc.id
  }
}

output "igw_ids" {
  value = {
  for k, igw in aws_internet_gateway.i :
  k => igw.id
  }
}

output "subnet_info" {
  value = {
  for k, subnet in local.subnets : k => subnet
  }
}

output "subnet_ids" {
  value = {
    for k, subnet in aws_subnet.i : k => subnet.id
  }
}


output "eip_ids" {
  value = {
  for k, eip in aws_eip.i : k => eip.id
  }
}

output "nat_gateway_ids" {
  value = {
  for k, ngw in aws_nat_gateway.i : k => ngw.id
  }
}
