terraform {
  backend "s3" {
    bucket         = "viwell-prod-infra"
    key            = "viwell/prod-infra/eks/eks.tfstate"
    region         = "me-central-1"
  }
}
