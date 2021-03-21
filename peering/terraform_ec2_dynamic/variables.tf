variable "public_key_path" {
  description = "Public key path"
}

variable "private_key_path" {
  description = "Private key path"
}

variable "instance_ami" {
  description = "AMI for aws EC2 instance"
}

variable "ami_id" {
  description = "AMI ID from available AMI's in AWS portal"
}

variable "ami_instance_type" {
  description = "Instance type for AMI"
}

variable "go_api_path" {
  description = "Path to GoApi that will be populated by local.tfvars"
}

variable "react_path" {
  description = "Path to React that will be populated by local.tfvars"
}