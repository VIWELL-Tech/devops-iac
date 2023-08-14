terraform {
  backend "s3" {
    bucket         = "viwell-prod-infra"
    key            = "viwell/prod-infra/cloudfront/portal.tfstate"
    region         = "me-central-1"
  }
}