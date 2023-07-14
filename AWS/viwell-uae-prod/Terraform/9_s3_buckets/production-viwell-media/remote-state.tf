terraform {
  backend "s3" {
    bucket         = "viwell-prod-infra"
    key            = "viwell/prod-infra/s3/s3.tfstate"
    region         = "me-central-1"
  }
}
