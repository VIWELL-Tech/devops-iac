variable "ami_id" {
    default=""
}
variable "instance_type" {
    default="" 
}
variable "key_name" {
    default="" 
}
variable "aws_vpc_net_id" {
    default=""
}
variable "subnet_ids" {
  type = list
  default=["",""]
}
variable "team_name" {
    default="DevOps"
}
variable "environment" {
    default=""
}
variable "team_owner" {
    default="DevOps"
}

variable "root_disk_size" {
    default=""
}

variable "instance_count" {
  default=""
}

variable "instance_name" {
  default=""
}

variable "service_name" {
  default=""
}

variable "sg_cidr" {
  default=""
}
variable "aws_iam_instance_profile" {
  default=""
}
variable "volume_type" {
  default="gp3"
}