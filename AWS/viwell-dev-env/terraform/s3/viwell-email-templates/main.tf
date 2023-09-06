provider "aws" {
  region = "us-east-1"

}

resource "aws_s3_bucket" "email-templates-dev" {
  bucket = "viwell-email-templates-dev"

  versioning {
    enabled = false
  }

}
resource "aws_s3_bucket" "templates-dev-b" {
  bucket = "viwell-email-templates-dev-b"

  versioning {
    enabled = false
  }

}
resource "aws_s3_bucket" "templates-test" {
  bucket = "viwell-email-templates-test"

  versioning {
    enabled = false
  }

}
resource "aws_s3_bucket" "templates-staging" {
  bucket = "viwell-email-templates-staging"

  versioning {
    enabled = false
  }

}
