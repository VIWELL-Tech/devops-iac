terraform {
  backend "s3" {
    bucket         = "viwell-prod-infra"
    key            = "sec/services/elastic-cache/redis.tfstate"
    region         = "me-central-1"
  }
}
