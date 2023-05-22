variable "aws-region" {
  default = ""
}

variable "caller-identity" {
  default = ""
}

variable "es-domain" {
  default = ""
}

variable "vpc-id" {
  default = ""
}

variable "cidrs-to-whitelist" {
  type = list
  default = []
}

variable "es-version" {
  default = ""
}

variable "instance-type" {
  default = ""
}

variable "pvt-sub-ids" {
  type = list
  default = []
}

variable "instance-count" {
  default = 2
}

variable "volume-size" {
  default = 50
}

variable "zone-count" {
  default = 2
}
