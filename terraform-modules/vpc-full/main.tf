provider "aws" {
  region  = var.region
}

locals {
  cidr_block_public  = cidrsubnet(var.cidr_block, 1, 0)
  cidr_block_private = cidrsubnet(var.cidr_block, 1, 1)
}

resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "vpc-${var.environment}"
  }
}

resource "aws_vpc_dhcp_options" "main" {
  domain_name         = "ec2.internal"
  domain_name_servers = ["169.254.169.253"]

  tags = {
    Name = var.environment
  }
}

resource "aws_vpc_dhcp_options_association" "main" {
  vpc_id          = aws_vpc.main.id
  dhcp_options_id = aws_vpc_dhcp_options.main.id
}

resource "aws_subnet" "private" {
  count = length(var.availability_zones)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnets[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet-${var.environment}-${count.index+1}"
  }
}

resource "aws_subnet" "public" {
  count = length(var.availability_zones)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(concat(var.public_subnets, [""]), count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${var.environment}-${count.index+1}"
  }
}

resource "aws_internet_gateway" "vpc" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.environment
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc.id
  }

  tags = {
    Name = "public-route-table-${var.environment}"
  }

  lifecycle {
    ignore_changes = [route]
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.availability_zones)

  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat_eip" {
  count = var.nat_gateways
  vpc   = true
}

resource "aws_nat_gateway" "private" {
  count         = var.nat_gateways
  allocation_id = element(aws_eip.nat_eip.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
}

resource "aws_route_table" "private" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-route-table-${var.environment}"
  }
}

resource "aws_route" "nat_routes" {
  count                  = length(var.availability_zones)
  destination_cidr_block = "0.0.0.0/0"

  route_table_id = element(aws_route_table.private.*.id, count.index)
  nat_gateway_id = element(aws_nat_gateway.private.*.id, count.index)
}

resource "aws_route_table_association" "private" {
  count = length(var.availability_zones)

  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.region}.s3"

  route_table_ids = flatten([
    aws_route_table.private.*.id,
    aws_route_table.public.*.id
  ])
}


resource "aws_flow_log" "this" {
  count                = var.flow_logs_enabled ? 1 : 0
  log_destination      = aws_s3_bucket.this[0].arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.main.id
}


# Bucket to store VPC flow logs.

resource "aws_s3_bucket" "this" {
  count  = var.flow_logs_enabled ? 1 : 0
  bucket = "${aws_vpc.main.id}-flowlogs"
  acl    = "private"
  tags   = var.tags
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "flow_log_id" {
  value       = length(aws_flow_log.this) > 0 ? aws_flow_log.this[0].id : ""
  description = "Flow Log ID"
}


