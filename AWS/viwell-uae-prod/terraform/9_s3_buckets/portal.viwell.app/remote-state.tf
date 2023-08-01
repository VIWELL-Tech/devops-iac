terraform {
    required_version = ">= 1.3.0"

  backend "s3" {
    bucket         = "viwell-prod-infra"
    key            = "viwell/prod-infra/s3/portal.tfstate"
    region         = "me-central-1"

  }
}
