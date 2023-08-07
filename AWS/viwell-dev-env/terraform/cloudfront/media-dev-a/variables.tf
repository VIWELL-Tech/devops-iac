variable "bucket_name" {
  description = "The name of the S3 bucket"
  default = "image-resize-dev-814880204573-us-east-1"
}
variable "bucket_domain_name" {
  description = "The name of the S3 domain name "
  default = "image-resize-dev-814880204573-us-east-1.s3.amazonaws.com"
}
variable "lambda_function_arn" {
  description = "ARN of the the Lambda Function "
  default = "arn:aws:lambda:us-east-1:814880204573:function:Image-Resize-dev:15"
}

variable "custom_domain_name" {
  description = "Custom domain name to use"
  default = "media-dev.viwell.app"
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM SSL certificate"
  default = "arn:aws:acm:us-east-1:814880204573:certificate/7b1db5c1-1bee-4955-8d31-53b0d20b8243"
}
