# Define the MongoDB Atlas Provider
terraform {
  required_providers {
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
    }
  }
  required_version = ">= 0.13"
}

provider "mongodbatlas" {
  public_key = "itlxqksq"
  private_key  = "2f45c050-cb75-4240-9e8e-fe00aa15ba07"
}