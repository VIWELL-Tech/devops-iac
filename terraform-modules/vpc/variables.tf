variable "cidr_block" {
  type = "list"
  default = [] #define subnets
}

variable "availability_zone" {
  type = "list"
  default = [] #define availability zone to place subnets in
}

variable "vpc_id" {
  default = ""
}

variable "create-subnets" {
  default = false
}

variable "create-route-table" {
  default = false
}


variable "subnet_tags" { #tags to attach with subnets
  type = "map"
  default = {
  }
}

variable "environment" {
  default = ""
}


variable "subnet-type" { #private or public #varibale used for tags
  default = ""
}


variable "tags" {
  type = "map"
  default = {

  }
}



variable "routes" {
  type = "list"
  default = []
}


variable "subnet_id" {
  type = "list"
  default = []
}

variable "route_table_id" {
  default = ""
}

variable "associate-subnet" {
  default = false
}

variable "subnet_count" {
  default = 0
}