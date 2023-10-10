provider "aws" {
  region = local.region
}

data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {}

locals {
  name    = "aggregates"
  region  = "me-central-1"
  region2 = ""

  vpc_cidr = "10.50.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Name       = local.name
    Example    = local.name
    Repository = "https://github.com/terraform-aws-modules/terraform-aws-rds"
  }
}

################################################################################
# RDS Module
################################################################################


module "db_default" {
  source = "../../"

  identifier                     = "${local.name}"
  instance_use_identifier_prefix = true

  create_db_option_group    = false
  create_db_parameter_group = false

  # All available versions: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html#PostgreSQL.Concepts
  engine               = "postgres"
  engine_version       = "15.4"
  family               = "postgres15" # DB parameter group
  major_engine_version = "15"         # DB option group
  instance_class       = "db.t3.small"

  allocated_storage = 20

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  db_name  = "prod_aggregates"
  username = "postgres"
  port     = 5432

  db_subnet_group_name   = "viwell-prod"
  vpc_security_group_ids = [module.security_group.security_group_id]

  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = 7

  deletion_protection = true

  tags = local.tags
}
################################################################################
# Supporting Resources
################################################################################

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = local.name
  description = "Complete PostgreSQL example security group"
  vpc_id      = "vpc-0c708b8993066e7fe"

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access from within VPC"
      cidr_blocks = "10.50.0.0/16"
    },
  ]

  tags = local.tags
}
