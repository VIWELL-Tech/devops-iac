variable "environment" {
  default = ""
}

variable "nat_gateways" {
  default = ""
}

variable "region" {
  default = ""
}

variable "cidr_block" {
  default = ""
}

variable "public_subnets" {}

variable "private_subnets" {}

variable "availability_zones" {
  type = list
}

variable "create_peering" {}

variable "flow_logs_enabled" {
  default     = "false"
  description = "Set to false to prevent the module from creating anything"
}

variable "bucket_region" {
  description = "S3 Bucket Region"
  default     = ""
}

variable "tags" {
  description = "Tags To Apply To Created Resources"
  default     = {}
}