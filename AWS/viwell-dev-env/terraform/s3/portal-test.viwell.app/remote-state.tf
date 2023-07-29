terraform {
    required_version = ">= 1.3.0"

  backend "s3" {
    bucket         = "viwell-dev-infra"
    key            = "dev/services/s3/portal-test.tfstate"
    region         = "us-east-1"
  }
}
