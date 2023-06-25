locals {
  name   = "dr-test"
  region = "us-west-2"
  tags = {
    Owner       = "DevOps Team"
    Environment = "Prod"

  }
}

################################################################################
# VPC Module
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"

  name = local.name
  cidr = "10.70.0.0/16"

  azs                              = ["${local.region}a", "${local.region}b"]
  private_subnets                  = ["10.70.22.0/24", "10.70.23.0/24"]
  public_subnets                   = ["10.70.20.0/24", "10.70.21.0/24"]
  manage_default_network_acl       = false
  default_network_acl_tags         = { Name = "${local.name}-default" }
  manage_default_route_table       = true
  default_route_table_tags         = { Name = "${local.name}-default" }
  manage_default_security_group    = true
  default_security_group_tags      = { Name = "${local.name}-default" }
  enable_dns_hostnames             = true
  enable_dns_support               = true
  enable_classiclink               = false
  enable_classiclink_dns_support   = false
  enable_nat_gateway               = true
  single_nat_gateway               = true
  enable_vpn_gateway               = false
  enable_dhcp_options              = false
  dhcp_options_domain_name         = "service.consul"
  dhcp_options_domain_name_servers = ["127.0.0.1", "10.10.0.2"]
  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log = false
  private_subnet_tags = {
    "kubernetes.io/cluster/${local.name}" = "shared"
    "kubernetes.io/role/internal-elb"     = 1
  }
  public_subnet_tags = {
    "kubernetes.io/cluster/${local.name}" = "shared"
    "kubernetes.io/role/elb"              = 1
  }
  tags = local.tags
}
