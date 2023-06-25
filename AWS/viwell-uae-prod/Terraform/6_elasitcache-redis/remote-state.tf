terraform {
  backend "s3" {
    bucket         = "viwell-prod-infra"
    key            = "viwell/prod-infra/elastic-cache/redis.tfstate"
    region         = "me-central-1"
  }
}
