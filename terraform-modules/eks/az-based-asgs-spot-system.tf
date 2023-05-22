locals {
  k8-worker-spot-system-userdata-1a = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --kubelet-extra-args --node-labels='lifecycle=Ec2Spot,az=1a,nodeType=systemNode' --apiserver-endpoint '${aws_eks_cluster.k8-cluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster.k8-cluster.certificate_authority.0.data}' '${var.cluster-name}' --kube-reserved 'cpu=250m,memory=1Gi,ephemeral-storage=1Gi' --system-reserved 'cpu=250m,memory=0.2Gi,ephemeral-storage=1Gi' --eviction-hard 'memory.available<1Gi,nodefs.available<10%'
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
systemctl start amazon-ssm-agent
systemctl enable amazon-ssm-agent
yum update -y
reboot
USERDATA

  k8-worker-spot-system-userdata-1b = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --kubelet-extra-args --node-labels='lifecycle=Ec2Spot,az=1b,nodeType=systemNode' --apiserver-endpoint '${aws_eks_cluster.k8-cluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster.k8-cluster.certificate_authority.0.data}' '${var.cluster-name}' --kube-reserved 'cpu=250m,memory=1Gi,ephemeral-storage=1Gi' --system-reserved 'cpu=250m,memory=0.2Gi,ephemeral-storage=1Gi' --eviction-hard 'memory.available<1Gi,nodefs.available<10%'
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
systemctl start amazon-ssm-agent
systemctl enable amazon-ssm-agent
yum update -y
reboot
USERDATA

  k8-worker-spot-system-userdata-1c = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --kubelet-extra-args --node-labels='lifecycle=Ec2Spot,az=1c,nodeType=systemNode' --apiserver-endpoint '${aws_eks_cluster.k8-cluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster.k8-cluster.certificate_authority.0.data}' '${var.cluster-name}' --kube-reserved 'cpu=250m,memory=1Gi,ephemeral-storage=1Gi' --system-reserved 'cpu=250m,memory=0.2Gi,ephemeral-storage=1Gi' --eviction-hard 'memory.available<1Gi,nodefs.available<10%'
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
systemctl start amazon-ssm-agent
systemctl enable amazon-ssm-agent
yum update -y
reboot
USERDATA
}

##### AVAILABILITY ZONE 1A #####

resource "aws_launch_template" "k8-worker-spot-system-lt" {
  count       = "${var.create_spot_workers}"
  name_prefix = "${var.environment}-k8-worker-spot-system-lt"

  iam_instance_profile {
    name = "${aws_iam_instance_profile.k8-worker.name}"
  }

  image_id               = "${var.aws_image_id}"
  instance_type          = "${var.instance_type}"
  vpc_security_group_ids = ["${aws_security_group.k8-worker.id}"]
  user_data              = "${base64encode(local.k8-worker-spot-system-userdata-1a)}"
  key_name               = "${var.key_name}"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_type = "gp2"
      volume_size = "${var.root_disk_size_in_GB}"
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = "${local.tags}"
}

resource "aws_autoscaling_group" "k8-worker-spot-system-asg" {
  capacity_rebalance  = true
  count               = "${var.create_spot_workers}"
  desired_capacity    = "${var.desired_spot_system-node}"
  max_size            = "${var.max_size_spot_system_node}"
  min_size            = "${var.min_size_spot_system_node}"
  name                = "${var.environment}-k8-worker-spot-system"
  vpc_zone_identifier = ["${var.aws_private_subnet_ids}"]

  mixed_instances_policy {
    instances_distribution {
      on_demand_percentage_above_base_capacity = 0
      spot_max_price                           = 0.2
      spot_allocation_strategy                 = "capacity-optimized" # The only valid value is capacity-optimized, which is also the default value. The Auto Scaling group selects the cheapest Spot pools and evenly allocates your Spot capacity across the number of Spot pools that you specify
    }

    launch_template {
      launch_template_specification {
        version            = "$$Latest"
        launch_template_id = "${aws_launch_template.k8-worker-spot-system-lt.id}"
      }

      override {
        instance_type = "${var.instance_type}"
      } 
         override {
         instance_type = "m4.xlarge"
       }

      # override {
      #   instance_type = "t3.large"
      # }

      # override {
      #   instance_type = "t2.large"
      # }

       override {
         instance_type = "m3.xlarge"
       }
   
    }
  }

  tag {
    key                 = "Name"
    value               = "${var.environment}-k8-worker-system-spot"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster-name}"
    value               = "owned"
    propagate_at_launch = true
  }

  tag {
    key                 = "Team"
    value               = "${var.team_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "${var.environment}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Owner"
    value               = "${var.team_owner}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Patch Group"
    value               = "${var.environment}-system"
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = ["desired_capacity"]
  }
}
