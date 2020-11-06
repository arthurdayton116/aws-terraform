terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true
  

  tags = {
    Name = "sample-company-vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "i_private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  map_public_ip_on_launch = false
  availability_zone = "us-west-2a"
  tags = {
    Name = "sample-company-vpc-subnet-private"
    Access = "private"
  }
}

resource "aws_subnet" "i_public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-west-2a"
  tags = {
    Name = "sample-company-vpc-subnet-public"
    Access = "public"
  }
}
