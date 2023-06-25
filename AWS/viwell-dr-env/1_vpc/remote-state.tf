terraform {
  backend "s3" {
    bucket         = "dr-test-viwell"
    key            = "infrastructure/prod/vpc.tfstate"
    region         = "us-west-2"
  }
}
