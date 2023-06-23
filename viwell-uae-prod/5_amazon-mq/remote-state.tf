terraform {
  backend "s3" {
    bucket = "dr-test-viwell"
    key    = "infrastructure/prod/amazon-mq.tfstate"
    region = "us-west-2"
  }
}
