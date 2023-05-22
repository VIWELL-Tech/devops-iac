module "vpn" {
  source         = "../../../terraform-modules/ec2/pritunl-vpn"
  instance_name  = "vpn-server"
  instance_count = 1
  key_name       = "shared-key"
  aws_vpc_net_id = "vpc-0248f2332ba000b46"
  subnet_ids     = ["subnet-0e432a74688be8a2a", "subnet-007323ebb426f5e31"] # public for vpn
  environment    = "shared"
  instance_type  = "t3.medium"
  ami_id         = "ami-0c4f7023847b90238"
  root_disk_size = "50"
  service_name   = "vpn-server"
  sg_cidr        = ["10.20.0.0/16"]
}