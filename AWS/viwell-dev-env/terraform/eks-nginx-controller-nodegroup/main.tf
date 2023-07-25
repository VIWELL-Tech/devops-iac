
module "self_managed_node_group" {
  source = "terraform-aws-modules/eks/aws//modules/self-managed-node-group"

  name                = "nginx-controller-self-mng"
  cluster_name        =  "dev-viwell"
  cluster_version     = "1.25"
  subnet_ids          =  ["subnet-0b4a643d057a201a7", "subnet-033a76deed0cb9a8a"]

  min_size     = 2
  max_size     = 2
  desired_size = 2

  launch_template_name = "nginx-controller-self-mng"
  instance_type        = "t3.small"

  create_iam_instance_profile = false
  iam_instance_profile_arn    = "arn:aws:iam::814880204573:instance-profile/dev-viwell-node-group-788b77c701a66edd-instance-profile"

  ebs_optimized     = true
  enable_monitoring = true
  block_device_mappings = {
    xvda = {
      device_name = "/dev/xvda"
      ebs = {
        volume_size           = 25
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
  // The following variables are necessary if you decide to use the module outside of the parent EKS module context.
  // Without it, the security groups of the nodes are empty and thus won't join the cluster.
  vpc_security_group_ids = [
    "sg-0cce59b47ad1af264"  ]

  ami_id                   = data.aws_ami.eks_default.id
  bootstrap_extra_args     = "--kubelet-extra-args '--max-pods=10 --node-labels group=standard-workers2 --register-with-taints special-nodegroup=ingress-nginx-workers:NoSchedule'"
  pre_bootstrap_user_data  = <<-EOT
  export CONTAINER_RUNTIME="containerd"
  export USE_MAX_PODS=false
  EOT
  post_bootstrap_user_data = <<-EOT
  echo "you are free little kubelet!"
  EOT


  # enable discovery of autoscaling groups by cluster-autoscaler
  autoscaling_group_tags = {
    "k8s.io/cluster-autoscaler/enabled" : true  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }

}

data "aws_caller_identity" "current" {}

data "aws_ami" "eks_default" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amazon-eks-node-1.25-v*"]
  }
}


