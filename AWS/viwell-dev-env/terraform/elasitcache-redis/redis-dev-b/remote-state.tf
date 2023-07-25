terraform {
  backend "s3" {
    bucket         = "viwell-dev-infra"
    key            = "dev/services/elastic-cache/redis-dev-b.tfstate"
    region         = "us-east-1"
  }
}
