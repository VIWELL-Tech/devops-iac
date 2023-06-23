locals {
  name   = "viwell-prod"
  region = "me-central-1"
  tags = {
    Owner       = "DevOps Team"
    Environment = "Production"
  
  }
}

################################################################################
# VPC Module
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"
  name = local.name
  cidr = "10.50.0.0/16" 

  azs                 = ["${local.region}a", "${local.region}b", "${local.region}d"]
  private_subnets     = ["10.50.0.0/20", "10.50.16.0/20", "10.50.32.0/20"]
  public_subnets      = ["10.50.48.0/24", "10.50.49.0/24", "10.50.50.0/24"]
  database_subnets    = ["10.50.51.0/24", "10.50.52.0/24", "10.50.53.0/24"]
  elasticache_subnets = ["10.50.54.0/24", "10.50.55.0/24", "10.50.56.0/24"]
  create_database_subnet_route_table    = true
  create_elasticache_subnet_route_table = true
  create_database_subnet_group = true
  manage_default_network_acl = false
  default_network_acl_tags   = { Name = "${local.name}-default" }
  manage_default_route_table = true
  default_route_table_tags   = { Name = "${local.name}-default" }
  manage_default_security_group = true
  default_security_group_tags   = { Name = "${local.name}-default" }
  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_classiclink             = false
  enable_classiclink_dns_support = false
  enable_nat_gateway = true
  single_nat_gateway = false
  enable_vpn_gateway = false
  enable_dhcp_options              = false
  dhcp_options_domain_name         = "service.consul"
  dhcp_options_domain_name_servers = ["127.0.0.1", "10.10.0.2"]
  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_max_aggregation_interval    = 60
  private_subnet_tags = {
    "kubernetes.io/cluster/viwell-prod" = "shared"
    "kubernetes.io/role/internal-elb"     = 1
  }
  public_subnet_tags = {
    "kubernetes.io/cluster/viwell-prod" = "shared"
    "kubernetes.io/role/elb"              = 1
  }
  tags = local.tags
}
