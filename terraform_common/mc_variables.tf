variable "base_tags_mc" {
  default = {
    owner       = "Minecraft"
    directory   = "terraform"
    createdBy   = "terraform"
    environment = "production"
    billTo      = "children"
  }
  description = "base resource tags"
  type        = map(string)
}

variable "resource_prefix_mc" {
  description = "Common prefix for resource names"
  default     = "minecraft"
}

variable "region_mc" {
  description = "Where resources will be deployed"
  default     = "us-west-2"
}

variable "config_mc" {
  default = "mc"
}
