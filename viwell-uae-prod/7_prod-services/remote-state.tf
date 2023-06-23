terraform {
  backend "s3" {
    bucket         = "dr-test-viwell"
    key            = "infrastructure/prod/prod-servicess.tfstate"
    region         = "us-west-2"
  }
}
