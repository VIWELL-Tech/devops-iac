terraform {
  backend "s3" {
    bucket         = "viwell-dev-infra"
    key            = "viwell/dev-infra/elastic-cache/redis-staging.tfstate"
    region         = "us-east-1"
  }
}
