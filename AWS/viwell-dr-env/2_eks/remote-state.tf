terraform {
  backend "s3" {
    bucket         = "dr-test-viwell"
    key            = "infrastructure/prod/eks.tfstate"
    region         = "us-west-2"
  }
}
