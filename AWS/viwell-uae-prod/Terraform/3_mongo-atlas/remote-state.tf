terraform {
  backend "s3" {
    bucket         = "viwell-prod-infra"
    key            = "viwell/prod-infra/eks/mongo.tfstate"
    region         = "me-central-1"

  }
}
