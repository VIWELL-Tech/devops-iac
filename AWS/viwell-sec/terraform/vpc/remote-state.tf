terraform {
  backend "s3" {
    bucket         = "viwell-prod-infra"
    key            = "viwell/sec-infra/vpc/vpc.tfstate"
    region         = "me-central-1"
  }
}
