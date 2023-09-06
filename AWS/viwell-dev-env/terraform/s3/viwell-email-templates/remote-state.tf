terraform {
    required_version = ">= 1.5.0"

  backend "s3" {
    bucket         = "viwell-dev-infra"
    key            = "dev/services/s3/email-template.tfstate"
    region         = "us-east-1"
  }
}
