variable "cloudflare_api_token" {
  description = "API token for Cloudflare"
  type        = string
}

variable "cloudflare_zone_id" {
  description = "The Cloudflare Zone ID"
  type        = string
  default     = "cf05f4fa00aee7afb8fe310a0224b6df"
}
