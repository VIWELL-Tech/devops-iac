terraform {
    required_version = ">= 1.5.0"

  backend "s3" {
    bucket         = "viwell-prod-infra"
    key            = "sec/services/s3/media.tfstate"
    region         = "me-central-1"
  }
}
