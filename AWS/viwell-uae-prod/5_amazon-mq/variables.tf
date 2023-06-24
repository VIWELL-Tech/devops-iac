
variable "region" {
  type        = string
  default     = "me-central-1"
}

variable "mq_admin_user" {
  type        = string
  default     = null
  description = "Admin username"
}

variable "mq_admin_password" {
  type        = string
  default     = null
  description = "Admin password"
}

variable "mq_application_user" {
  type        = string
  default     = null
  description = "Application username"
}

variable "mq_application_password" {
  type        = string
  default     = null
  description = "Application password"
}