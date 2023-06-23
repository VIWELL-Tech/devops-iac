terraform {
  backend "s3" {
    bucket         = "viwell-prod-infra"
    key            = "viwell/prod-infra/vpc/vpc.tfstate"
    region         = "me-central-1"
  }
}
