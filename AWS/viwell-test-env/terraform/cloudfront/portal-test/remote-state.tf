terraform {
  backend "s3" {
    bucket         = "viwell-dev-infra"
    key            = "dev/services/cloudfront/portal-test.tfstate"
    region         = "us-east-1"
  }
}