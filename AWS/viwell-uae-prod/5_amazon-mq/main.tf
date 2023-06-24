provider "aws" {
  region = var.region
}

module "mq_broker" {
  source  = "cloudposse/mq-broker/aws"
  version = "2.0.1"

  vpc_id     = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets

  allowed_security_group_ids = [data.terraform_remote_state.eks.outputs.eks_nodes_security_group]
  allowed_cidr_blocks        = [data.terraform_remote_state.vpc.outputs.vpc_cidr_block]
  allowed_ingress_ports      = [8162, 5671, 443]
  region                     = "me-central-1"
  name                       = "viwell-prod"
  apply_immediately          = "true"
  auto_minor_version_upgrade = "true"
  deployment_mode            = "Single-instance broker"
  engine_type                = "RabbitMQ"
  engine_version             = "3.10.20"
  host_instance_type         = "mq.t3.micro"
  publicly_accessible        = "false"
  general_log_enabled        = "true"
  audit_log_enabled          = "true"
  encryption_enabled         = "true"
  mq_admin_user              = [var.mq_admin_user]
  mq_admin_password          = [var.mq_admin_password] 
  # ssm_path = "eg/mq/${var.attributes[0]}"

  security_group_create_before_destroy = true

  # context = module.this.context
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket         = "viwell-prod-infra"
    key            = "viwell/prod-infra/vpc/vpc.tfstate"
    region         = "me-central-1"
      }
}

data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket         = "viwell-prod-infra"
    key            = "viwell/prod-infra/eks/eks.tfstate"
    region         = "me-central-1"
  }
}