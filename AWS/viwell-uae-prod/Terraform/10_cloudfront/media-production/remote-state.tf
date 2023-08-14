terraform {
  backend "s3" {
    bucket         = "viwell-prod-infra"
    key            = "viwell/prod-infra/cloudfront/media.tfstate"
    region         = "me-central-1"
  }
}