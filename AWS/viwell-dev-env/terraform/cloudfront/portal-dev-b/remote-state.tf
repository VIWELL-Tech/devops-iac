terraform {
  backend "s3" {
    bucket         = "viwell-dev-infra"
    key            = "dev/services/cloudfront/portal-dev-b.tfstate"
    region         = "us-east-1"
  }
}