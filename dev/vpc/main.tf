module "vpc-full" {
  source             = "../../terraform-modules/vpc-full"
  environment        = "dev" # vpc name
  region             = "us-east-1"
  availability_zones = ["us-east-1a", "us-east-1b"] # add add the third AZ if wanted
  nat_gateways       = 1
  cidr_block         = "10.21.0.0/16"
  private_subnets    = ["10.21.1.0/24", "10.21.2.0/24"]
  public_subnets     = ["10.21.3.0/24", "10.21.4.0/24"]
  create_peering     = false
}