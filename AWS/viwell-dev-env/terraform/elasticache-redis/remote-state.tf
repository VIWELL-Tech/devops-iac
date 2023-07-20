terraform {
  backend "s3" {
    bucket = "viwell-iac"
    key    = "dev/services/redis/redis.tfstate"
    region = "us-east-1"
  }
}
