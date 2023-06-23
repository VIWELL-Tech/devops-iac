terraform {
  backend "s3" {
    bucket = "dr-test-viwell"
    key    = "infrastructure/prod/msk-apache-kafka-cluster.tfstate"
    region = "us-west-2"
  }
}
