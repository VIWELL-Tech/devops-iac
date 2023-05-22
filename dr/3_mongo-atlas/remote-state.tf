terraform {
  backend "s3" {
    bucket         = "dr-test-viwell"
    key            = "infrastructure/prod/mongo-atlas.tfstate"
    region         = "us-west-2"
  }
}
