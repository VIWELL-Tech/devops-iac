terraform {
  backend "s3" {
    bucket = "dr-test-viwell"
    key    = "infrastructure/prod/redis.tfstate"
    region = "us-west-2"
  }
}
