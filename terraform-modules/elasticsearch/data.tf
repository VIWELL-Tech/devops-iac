
data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_subnet_ids" "subnet_ids" {
  vpc_id = data.aws_vpc.selected.id

  tags = {
    Name = "private-*"
  }
}

data "aws_subnet" "subnet-1" {
  tags = {
    Name = "private-*-1a"
  }
}

data "aws_subnet" "subnet-2" {
  tags = {
    Name = "private-*-1b"
  }
}