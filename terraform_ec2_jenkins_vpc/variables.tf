variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default     = "10.1.0.0/19"
}
variable "cidr_subnet_public" {
  description = "CIDR block for the subnet"
  default     = "10.1.0.0/24"
}
variable "jenkins_subnet_private_ip" {
  description = "CIDR block for the subnet"
  default     = "10.1.0.10"
}
//variable "cidr_subnet_private" {
//  description = "CIDR block for the subnet"
//  default     = "10.1.1.0/24"
//}
variable "availability_zone" {
  description = "availability zone to create subnet"
  default     = "us-west-2a"
}

variable "region" {
  description = "Where resources will be deployed"
  default     = "us-west-2"
}

variable "base_tags" {
  default = {
    owner       = "Hypothetical"
    createdBy   = "terraform"
    environment = "production"
    billTo      = "study"
  }
  description = "base resource tags"
  type        = map(string)
}

variable "resource_prefix" {
  description = "Common prefix for resource names"
  default     = "jenkins"
}
