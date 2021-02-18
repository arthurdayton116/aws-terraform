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

variable "environment_tag" {
  description = "Environment tag"
  default     = "Production"
}

variable "resource_prefix" {
  description = "Common prefix for resource names"
  default     = "sample_company"
}
