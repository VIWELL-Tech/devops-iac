terraform {
  backend "s3" {
    bucket         = "dr-test-viwell"
    key            = "infrastructure/prod/ecr.tfstate"
    region         = "us-west-2"
  }
}
