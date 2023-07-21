terraform {
  backend "s3" {
    bucket         = "viwell-dev-infra"
    key            = "viwell/dev-infra/elastic-cache/redis-test.tfstate"
    region         = "us-east-1"
  }
}
