locals {
  name            = "dr-test-eks"
  cluster_version = "1.23"
  region          = "us-west-2"
  vpc_id          = data.terraform_remote_state.vpc.outputs.vpc_id
  # from public and private subnets outputs
  subnet_ids = data.terraform_remote_state.vpc.outputs.public_and_private_subnets

  tags = {
    Owners      = "DevOpsTeam"
    Environment = "Prod"
  }
}

################################################################################
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  cluster_name                    = local.name
  cluster_version                 = local.cluster_version
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  vpc_id                          = local.vpc_id
  subnet_ids                      = local.subnet_ids

  # Self managed node groups will not automatically create the aws-auth configmap so we need to
  create_aws_auth_configmap = true
  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::814880204573:role/jenkins"
      username = "jenkins-role"
      groups   = ["system:masters"]
    },
    {
      rolearn  = "arn:aws:iam::814880204573:role/self-managed-node-group-prod"
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes"]
    }
  ]
  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::814880204573:user/abdulrahman.hassan@slashtec.com"
      username = "abdulrahman.hassan"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::814880204573:user/devops-01"
      username = "Basim"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::814880204573:user/muhamd.abdelhaliem@slashtec.com"
      username = "muhamd.abdelhaliem@slashtec.com"
      groups   = ["system:masters"]
    }
  ]

  aws_auth_accounts         = ["814880204573"]
  manage_aws_auth_configmap = true
  # Extend cluster security group rules
  cluster_security_group_additional_rules = {
    ingress_nodes_ephemeral_ports_tcp = {
      description = " To master"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "ingress"
      cidr_blocks = ["0.0.0.0/0"]
    }
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }

  # Extend node-to-node security group rules
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
    ingress_allow_access_from_control_plane_alb_controller = {
      type                          = "ingress"
      protocol                      = "tcp"
      from_port                     = 9443
      to_port                       = 9443
      source_cluster_security_group = true
      description                   = "Allow access from control plane to webhook port of AWS load balancer controller"
    }
    ingress_allow_access_from_control_plane_metric_server = {
      type                          = "ingress"
      protocol                      = "tcp"
      from_port                     = 4443
      to_port                       = 4443
      source_cluster_security_group = true
      description                   = "Allow access from control plane to webhook port of Metric Server"
    }
  }

  self_managed_node_group_defaults = {
    create_security_group = false

    # enable discovery of autoscaling groups by cluster-autoscaler
    autoscaling_group_tags = {
      "k8s.io/cluster-autoscaler/enabled" : true,
      "k8s.io/cluster-autoscaler/${local.name}" : "owned",
    }
  }

  self_managed_node_groups = {

    on-demand = {
      name            = "${local.name}-self-mng"
      use_name_prefix = false
      subnet_ids      = data.terraform_remote_state.vpc.outputs.private_subnets # from private subnets outputs
      min_size        = 4
      max_size        = 6
      desired_size    = 4

      ami_id               = data.aws_ami.eks_default.id
      bootstrap_extra_args = "--kubelet-extra-args '--max-pods=110 --node-labels group=standard-workers2'"

      pre_bootstrap_user_data         = <<-EOT
      export CONTAINER_RUNTIME="containerd"
      export USE_MAX_PODS=false
      EOT
      post_bootstrap_user_data        = <<-EOT
      echo "you are free little kubelet!"
      EOT
      instance_type                   = "t3.large"
      launch_template_name            = "self-managed-${local.name}"
      launch_template_use_name_prefix = true
      launch_template_description     = "Self managed node group ${local.name} launch template"
      ebs_optimized                   = true
      vpc_security_group_ids          = [aws_security_group.additional.id]
      enable_monitoring               = true
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 75
            volume_type           = "gp3"
            iops                  = 3000
            throughput            = 150
            encrypted             = true
            delete_on_termination = true
          }
        }
      }
      metadata_options = {
        http_endpoint               = "enabled"
        http_tokens                 = "required"
        http_put_response_hop_limit = 2
        instance_metadata_tags      = "disabled"
      }
      create_iam_role          = true
      iam_role_name            = "self-managed-node-group-${local.name}"
      iam_role_use_name_prefix = false
      iam_role_description     = "Self managed node group ${local.name}"
      iam_role_tags = {
        Purpose = "Protector of the kubelet"
      }
      iam_role_additional_policies = [
        "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
        "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
        "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy",
        "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess",
        "arn:aws:iam::aws:policy/AutoScalingFullAccess"

      ]
      create_security_group          = true
      security_group_name            = "self-managed-node-group-${local.name}"
      security_group_use_name_prefix = false
      security_group_description     = "Self managed node group ${local.name} security group"

      security_group_rules = {
        phoneOut = {
          description = "Hello CloudFlare"
          protocol    = "udp"
          from_port   = 53
          to_port     = 53
          type        = "egress"
          cidr_blocks = ["1.1.1.1/32"]
        }
        phoneHome = {
          description                   = "Hello cluster"
          protocol                      = "udp"
          from_port                     = 53
          to_port                       = 53
          type                          = "egress"
          source_cluster_security_group = true # bit of reflection lookup
        }
      }

      security_group_tags = {
        Purpose = "Protector of the kubelet"
      }

      timeouts = {
        create = "80m"
        update = "80m"
        delete = "80m"
      }

      tags = {
        ExtraTag = "Self managed node group ${local.name}"
      }
    }
  }
  tags = local.tags
}

################################################################################
# Supporting Resources
################################################################################
resource "aws_security_group" "additional" {
  name_prefix = "${local.name}-additional"
  vpc_id      = local.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
      data.terraform_remote_state.vpc.outputs.vpc_cidr_block
    ]
  }

  tags = local.tags
}

resource "time_sleep" "wait_3_minutes" {
  depends_on = [module.eks]

  create_duration = "3m"
}
resource "aws_eks_addon" "kube_proxy" {
  cluster_name = module.eks.cluster_id
  addon_name   = "kube-proxy"
  depends_on   = [time_sleep.wait_3_minutes]
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name      = module.eks.cluster_id
  addon_name        = "vpc-cni"
  resolve_conflicts = "OVERWRITE"
  depends_on        = [time_sleep.wait_3_minutes]
}

resource "aws_eks_addon" "coredns" {
  cluster_name      = module.eks.cluster_id
  addon_name        = "coredns"
  resolve_conflicts = "OVERWRITE"
  depends_on        = [aws_eks_addon.vpc_cni]
}
resource "aws_eks_addon" "aws_ebs_csi_driver" {
  cluster_name      = module.eks.cluster_id
  addon_name        = "aws-ebs-csi-driver"
  resolve_conflicts = "OVERWRITE"
  depends_on        = [time_sleep.wait_3_minutes]
}

data "aws_caller_identity" "current" {}
data "aws_ami" "eks_default" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amazon-eks-node-${local.cluster_version}-v*"]
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "dr-test-viwell"
    key    = "infrastructure/prod/vpc.tfstate"
    region = "us-west-2"
  }
}

## storage classes

resource "kubernetes_storage_class" "gp3" {

  depends_on = [aws_eks_addon.aws_ebs_csi_driver]

  metadata {
    name = "gp3"
  }
  storage_provisioner    = "ebs.csi.aws.com"
  allow_volume_expansion = "true"
  volume_binding_mode    = "WaitForFirstConsumer"
  reclaim_policy         = "Retain"
  parameters = {
    fsType = "ext4"
    type   = "gp3"
  }
  mount_options = []
}

# create mon namespace
resource "kubernetes_namespace" "mon" {
  depends_on = [module.eks]
  metadata {
    annotations = {
      name = "mon"
    }

    labels = {
      purpose = "monitoring_logging"
    }

    name = "mon"
  }
}

# create prod namespace
resource "kubernetes_namespace" "prod" {
  depends_on = [module.eks]
  metadata {
    annotations = {
      name = "prod"
    }

    labels = {
      purpose = "production_services"
    }

    name = "prod"
  }
}

resource "null_resource" "merge_kubeconfig" {
  triggers = {
    always = timestamp()
  }

  depends_on = [module.eks]

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command = <<EOT
      set -e
      echo 'Applying Auth ConfigMap with kubectl...'
      aws eks wait cluster-active --name '${local.name}'
      aws eks update-kubeconfig --name '${local.name}' --alias '${local.name}' --region=${local.region}
    EOT
  }
}