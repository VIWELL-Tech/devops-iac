module "jenkins" {
  source         = "../../../terraform-modules/ec2/jenkins"
  instance_name  = "jenkins"
  instance_count = 1
  key_name       = "shared-key"
  aws_vpc_net_id = "vpc-0248f2332ba000b46"
  subnet_ids     = ["subnet-0a5282b432ab84343", "subnet-0f745fef8c13b1452"] # private for jenkins
  environment    = "shared"
  instance_type  = "t3a.large"
  ami_id         = "ami-0022f774911c1d690"
  root_disk_size = "100"
  service_name   = "jenkins"
  sg_cidr        = ["10.20.0.0/16"]
}
