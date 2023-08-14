terraform {
  backend "s3" {
    bucket         = "viwell-dev-infra"
    key            = "dev/services/cloudfront/media-staging.tfstate"
    region         = "us-east-1"
  }
}