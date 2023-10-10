terraform {
  backend "s3" {
    bucket         = "viwell-prod-infra"
    key            = "viwell/prod-infra/rds/rds.tfstate"
    region         = "me-central-1"
  }
}
