terraform {
    required_version = ">= 1.3.0"

  backend "s3" {
    bucket         = "viwell-prod-infra"
    key            = "sec/services/s3/portal.tfstate"
    region         = "me-central-1"

  }
}
