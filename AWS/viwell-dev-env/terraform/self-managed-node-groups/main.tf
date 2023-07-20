# -----------------------------------------------------------------------------
# Deploy a self-managed node group in an AWS Region
# -----------------------------------------------------------------------------
module "eks_self_managed_node_group" {
  source = "../../terraform-modules/self-managed-node-groups"

  region           = "us-east-1"
  eks_cluster_name = "dev-viwell"
  instance_type    = "t3a.large"
  ebs_volume_size  = 100
  ebs_volume_type  = "gp3"
  key_name         = "dev-key"
  desired_capacity = 2
  min_size         = 2
  max_size         = 3
  subnets          = ["subnet-0b4a643d057a201a7", "subnet-033a76deed0cb9a8a"] # Region subnet(s)

  create_spot_workers   = false
  instance_type_spot    = "t3a.large"
  desired_capacity_spot = 2
  min_size_spot         = 1
  max_size_spot         = 3
  node_labels = {
  #   "node.kubernetes.io/node-group" = "node-group-a" # (Optional) node-group name label
  "lifecycle" = "Ec2Spot"
  }
}