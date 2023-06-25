terraform {
  backend "s3" {
    bucket         = "viwell-prod-infra"
    key            = "viwell/prod-infra/msk/msk.tfstate"
    region         = "me-central-1"
  }
}
