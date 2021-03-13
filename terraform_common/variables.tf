variable "base_tags" {
  default = {
    owner       = "Sample Company"
    createdBy   = "terraform"
    environment = "production"
    billTo      = "study"
  }
  description = "base resource tags"
  type        = map(string)
}

variable "resource_prefix" {
  description = "Common prefix for resource names"
  default     = "sample-company"
}

variable "region" {
  description = "Where resources will be deployed"
  default     = "us-west-2"
}
