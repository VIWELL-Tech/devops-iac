terraform {
  backend "s3" {
    bucket         = "viwell-dev-infra"
    key            = "dev/services/cloudfront/media-dev.tfstate"
    region         = "us-east-1"
  }
}