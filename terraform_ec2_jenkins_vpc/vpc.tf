# Configure the AWS Provider
provider "aws" {
  region = local.region
}

## Create vpc
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_vpc
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    local.base_tags,
    {
      Name = "${local.resource_prefix}-vpc"
    },
  )
}

## Create internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    local.base_tags,
    {
      Name = "${local.resource_prefix}-igw"
    },
  )
}

## Create public subnet
resource "aws_subnet" "subnet_public" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.cidr_subnet_public
  map_public_ip_on_launch = "true"
  availability_zone       = var.availability_zone
  tags = merge(
    local.base_tags,
    {
      Name   = "${local.resource_prefix}-vpc-subnet-public"
      Access = "public"
    },
  )
}

//## Create private subnet
//resource "aws_subnet" "subnet_private" {
//  vpc_id                  = aws_vpc.vpc.id
//  cidr_block              = var.cidr_subnet_private
//  map_public_ip_on_launch = "false"
//  availability_zone       = var.availability_zone
//  tags = merge(
//    local.base_tags,
//    {
//      Name   = "${local.resource_prefix}-vpc-subnet-private"
//      Access = "private"
//    },
//  )
//}

resource "aws_eip" "jenkins_public_ip" {
  vpc                       = true
  associate_with_private_ip = var.jenkins_subnet_private_ip
  depends_on                = [aws_internet_gateway.igw]

  tags = merge(
    local.base_tags,
    {
      Name = "${local.resource_prefix}-public-ip"
    },
  )
}



