variable "public_key_path" {
  description = "Public key path"
  default     = "~/.ssh/id_rsa_ec2.pub"
}
//variable "instance_ami" {
//  description = "AMI for aws EC2 instance"
//  default     = "ami-0cf31d971a3ca20d6"
//}
//variable "instance_type" {
//  description = "type for aws EC2 instance"
//  default     = "t2.micro"
//}

variable "ami_id" {
  description = "AMI ID from available AMI's in AWS portal"
  default     = "ami-07a29e5e945228fa1"
}

variable "ami_instance_type" {
  description = "Instance type for AMI"
  default     = "t3.xlarge"
}

variable "region" {
  description = "Where resources will be deployed"
  default     = "us-west-2"
}

