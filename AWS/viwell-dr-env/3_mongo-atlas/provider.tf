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
  public_key = "erlmfwip"
  private_key  = "c139c8b4-17c8-42cd-a2f4-784d38423c04"
}