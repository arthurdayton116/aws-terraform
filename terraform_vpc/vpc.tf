# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
}

## Create main route table
resource "aws_route_table" "main" {
  tags = merge(
  var.base_tags,
  {
    Name = "${var.resource_prefix}-main-rt"
  },
  )
  vpc_id = aws_vpc.vpc.id
}

resource "aws_default_route_table" "main" {
  tags = merge(
  var.base_tags,
  {
    Name = "${var.resource_prefix}-main-rt"
  },
  )
  default_route_table_id = aws_route_table.main.id
}

resource "aws_main_route_table_association" "main" {
  vpc_id         = aws_vpc.vpc.id
  route_table_id = aws_route_table.main.id
}

## Create vpc
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_vpc
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.base_tags,
    {
      Name = "${var.resource_prefix}-vpc"
    },
  )
}

## Create internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    var.base_tags,
    {
      Name = "${var.resource_prefix}-igw"
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
    var.base_tags,
    {
      Name   = "${var.resource_prefix}-vpc-subnet-public"
      Access = "public"
    },
  )
}

## Create private subnet
resource "aws_subnet" "subnet_private" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.cidr_subnet_private
  map_public_ip_on_launch = "false"
  availability_zone       = var.availability_zone
  tags = merge(
    var.base_tags,
    {
      Name   = "${var.resource_prefix}-vpc-subnet-private"
      Access = "private"
    },
  )
}

## Create route table
resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(
  var.base_tags,
  {
    Name = "${var.resource_prefix}-rt"
  },
  )
}

## Associate route tables with subnets
resource "aws_route_table_association" "rta_subnet_private" {
  subnet_id      = aws_subnet.subnet_private.id
  route_table_id = aws_default_route_table.main.id
}

resource "aws_route_table_association" "rta_subnet_public" {
  subnet_id      = aws_subnet.subnet_public.id
  route_table_id = aws_route_table.rtb_public.id
}




