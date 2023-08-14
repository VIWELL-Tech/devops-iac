variable "bucket_name" {
  description = "The name of the S3 bucket"
  default = "portal-staging.viwell.app"
}
variable "bucket_domain_name" {
  description = "The name of the S3 domain name "
  default = "portal-staging.viwell.app.s3.me-central-1.amazonaws.com"
}

variable "custom_domain_name" {
  description = "Custom domain name to use"
  default = "portal-staging.viwell.app"
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM SSL certificate"
  default = "arn:aws:acm:us-east-1:814880204573:certificate/7b1db5c1-1bee-4955-8d31-53b0d20b8243"
}
