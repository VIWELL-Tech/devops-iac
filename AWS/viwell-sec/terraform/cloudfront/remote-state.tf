terraform {
  backend "s3" {
    bucket         = "viwell-prod-infra"
    key            = "sec/services/cloudfront/media.tfstate"
    region         = "me-central-1"
  }
}