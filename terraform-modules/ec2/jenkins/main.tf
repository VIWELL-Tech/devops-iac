locals {
  tags = {
    "Team"        = "${var.team_name}"
    "Environment" = "${var.environment}"
    "Owner"       = "${var.team_owner}"
    "Name"        = "${var.environment}-${var.instance_name}"
  }

  subnet_ids_list = tolist(var.subnet_ids)
  subnet_ids_random_index = random_id.index.dec % length(var.subnet_ids)
  instance_subnet_id = local.subnet_ids_list[local.subnet_ids_random_index]
}

resource random_id index {
  byte_length = 2
}

resource "aws_security_group" "jenkins" {
   name        = "jenkins"
   description = "Allow private traffic for ${var.instance_name} node"
   vpc_id      = var.aws_vpc_net_id

   egress {
     from_port   = 0
     to_port     = 0
     protocol    = "-1"
     cidr_blocks = ["0.0.0.0/0"]
   }

   ingress {
     from_port   = 0
     to_port     = 0
     protocol    = "-1"
     cidr_blocks = var.sg_cidr
   }
}

#data "aws_security_group" "jenkins-vpn" {
#  name = "jenkins-vpn"
#}


resource "aws_instance" "jenkins" {
  count           = var.instance_count
  ami             = var.ami_id
  instance_type   = var.instance_type
  user_data       = data.template_file.instance-user-data.rendered
  key_name        = var.key_name
  iam_instance_profile = var.aws_iam_instance_profile
  vpc_security_group_ids = [aws_security_group.jenkins.id]
  subnet_id       = local.instance_subnet_id
  tags            = local.tags
  volume_tags     = local.tags
  root_block_device {
    volume_size   = var.root_disk_size
    volume_type = var.volume_type
  }
  depends_on = [aws_security_group.jenkins]
}
output "instance_ip" {
  value = aws_instance.jenkins.*.private_ip
}