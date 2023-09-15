provider "aws" {
  region = "me-central-1"

}

resource "aws_s3_bucket" "email-templates-prod" {
  bucket = "viwell-analytics"

  versioning {
    enabled = false
  }

}