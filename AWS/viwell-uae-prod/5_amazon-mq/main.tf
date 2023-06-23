provider "aws" {
  region = var.region
}

# module "vpc" {
#   source  = "cloudposse/vpc/aws"
#   version = "1.1.0"

#   cidr_block = "172.16.0.0/16"

#   context = module.this.context
# }

# module "subnets" {
#   source  = "cloudposse/dynamic-subnets/aws"
#   version = "1.0.0"

#   availability_zones   = var.availability_zones
#   vpc_id               = module.vpc.vpc_id
#   igw_id               = module.vpc.igw_id
#   cidr_block           = module.vpc.vpc_cidr_block
#   nat_gateway_enabled  = false
#   nat_instance_enabled = false

#   context = module.this.context
# }

module "mq_broker" {
  source  = "cloudposse/mq-broker/aws"
  version = "2.0.1"

  vpc_id     = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets

  allowed_security_group_ids = [data.terraform_remote_state.eks.outputs.eks_nodes_security_group]
  allowed_cidr_blocks        = [data.terraform_remote_state.vpc.outputs.vpc_cidr_block]
  allowed_ingress_ports      = [8162, 5671, 443]

  name                       = var.name
  apply_immediately          = var.apply_immediately
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  deployment_mode            = var.deployment_mode
  engine_type                = var.engine_type
  engine_version             = var.engine_version
  host_instance_type         = var.host_instance_type
  publicly_accessible        = var.publicly_accessible
  general_log_enabled        = var.general_log_enabled
  audit_log_enabled          = var.audit_log_enabled
  kms_ssm_key_arn            = var.kms_ssm_key_arn
  encryption_enabled         = var.encryption_enabled
  kms_mq_key_arn             = var.kms_mq_key_arn
  use_aws_owned_key          = var.use_aws_owned_key
  mq_admin_user              = [var.mq_admin_user]
  mq_admin_password          = [var.mq_admin_password]
  mq_application_user        = [var.mq_application_user]
  mq_application_password    = [var.mq_application_password]

  # ssm_path = "eg/mq/${var.attributes[0]}"

  security_group_create_before_destroy = true

  # context = module.this.context
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "dr-test-viwell"
    key    = "infrastructure/prod/vpc.tfstate"
    region = "us-west-2"
  }
}

data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "dr-test-viwell"
    key    = "infrastructure/prod/eks.tfstate"
    region = "us-west-2"
  }
}