variable "rabbitmq_password" {
  type        = string
  description = "amazon mq password"
  sensitive   = true
  default     = "viwelldrmqdemo"
}

variable "services" {
  description = "list of backend services"
  type        = list(string)
  default     = ["activity", "assessment"]
}