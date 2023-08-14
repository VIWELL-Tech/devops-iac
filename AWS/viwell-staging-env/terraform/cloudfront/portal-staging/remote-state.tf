terraform {
  backend "s3" {
    bucket         = "viwell-dev-infra"
    key            = "dev/services/cloudfront/portal-staging.tfstate"
    region         = "us-east-1"
  }
}