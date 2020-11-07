variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default     = "10.1.0.0/16"
}
variable "cidr_subnet_public" {
  description = "CIDR block for the subnet"
  default     = "10.1.0.0/24"
}
variable "cidr_subnet_private" {
  description = "CIDR block for the subnet"
  default     = "10.1.1.0/24"
}
variable "availability_zone" {
  description = "availability zone to create subnet"
  default     = "us-west-2a"
}
variable "public_key_path" {
  description = "Public key path"
  default     = "~/.ssh/id_rsa_ec2.pub"
}
variable "instance_ami" {
  description = "AMI for aws EC2 instance"
  default     = "ami-0cf31d971a3ca20d6"
}
variable "instance_type" {
  description = "type for aws EC2 instance"
  default     = "t2.micro"
}
variable "environment_tag" {
  description = "Environment tag"
  default     = "Production"
}

variable "resource_prefix" {
  description = "Common prefix for resource names"
  default     = "sample_company"
}

variable "ami_id" {
  description = "AMI ID from available AMI's in AWS portal"
  default     = "ami-07a29e5e945228fa1"
}

variable "ami_instance_type" {
  description = "Instance type for AMI"
  default     = "t3.micro"
}