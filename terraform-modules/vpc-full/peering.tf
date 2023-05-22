resource "aws_vpc_peering_connection" "peer_nprd" {
  count         = var.create_peering ? 1 : 0
  peer_vpc_id   = "vpc-0f81e529588b6ebf0"
  vpc_id        = "${aws_vpc.main.id}"
  peer_owner_id = "387139262264"
  peer_region   = "us-east-1"
  depends_on    = [aws_vpc.main]
  tags          = {
    Name        = "peer-nprd"
  }
}

resource "aws_vpc_peering_connection" "peer_gcc" {
  count         = var.create_peering ? 1 : 0
  peer_vpc_id   = "vpc-0e946c84ebcb4fa1f"
  vpc_id        = "${aws_vpc.main.id}"
  peer_owner_id = "036126126516"
  peer_region   = "us-east-1"
  depends_on    = [aws_vpc.main]
  tags          = {
    Name        = "peer-gcc"
  }
}

resource "aws_vpc_peering_connection" "peer_moe" {
  count         = var.create_peering ? 1 : 0
  peer_vpc_id   = "vpc-04f105b0a41068df0"
  vpc_id        = "${aws_vpc.main.id}"
  peer_owner_id = "356075791762"
  peer_region   = "us-east-1"
  depends_on    = [aws_vpc.main]
  tags          = {
    Name        = "peer-moe"
  }
}

resource "aws_vpc_peering_connection" "peer_us" {
  count         = var.create_peering ? 1 : 0
  peer_vpc_id   = "vpc-04805cef391dd6e02"
  vpc_id        = "${aws_vpc.main.id}"
  peer_owner_id = "227230898201"
  peer_region   = "us-east-2"
  depends_on    = [aws_vpc.main]
  tags          = {
    Name        = "peer-us"
  }
}

resource "aws_vpc_peering_connection" "peer_bigdata" {
  count         = var.create_peering ? 1 : 0
  peer_vpc_id   = "vpc-02ce557f58474dbf3"
  vpc_id        = "${aws_vpc.main.id}"
  peer_owner_id = "368318908727"
  peer_region   = "us-east-1"
  depends_on    = [aws_vpc.main]
  tags          = {
    Name        = "peer-bigdata"
  }
}

resource "aws_vpc_peering_connection" "peer_fortinet" {
  count         = var.create_peering ? 1 : 0
  peer_vpc_id   = "vpc-0b330a65477b9c9f4"
  vpc_id        = "${aws_vpc.main.id}"
  peer_owner_id = "190345255876"
  peer_region   = "us-east-1"
  depends_on    = [aws_vpc.main]
  tags          = {
    Name        = "peer-fortinet"
  }
}

resource "aws_vpc_peering_connection" "peer_shared" {
  count         = var.create_peering ? 1 : 0
  peer_vpc_id   = "vpc-0e208e24121de54fc"
  vpc_id        = "${aws_vpc.main.id}"
  peer_owner_id = "190345255876"
  peer_region   = "us-east-1"
  depends_on    = [aws_vpc.main]
  tags          = {
    Name        = "peer-shared"
  }
}

resource "aws_route" "add-routes-nprd-1" {
  count                     = var.create_peering ? length(var.availability_zones) : 0
  destination_cidr_block    = "192.168.16.0/22"
  vpc_peering_connection_id = element(aws_vpc_peering_connection.peer_nprd.*.id, 0)
  route_table_id            = element(aws_route_table.private.*.id, count.index)
}

resource "aws_route" "add-routes-nprd-2" {
  count                     = var.create_peering ? length(var.availability_zones) : 0
  destination_cidr_block    = "100.64.0.0/16"
  vpc_peering_connection_id = element(aws_vpc_peering_connection.peer_nprd.*.id, 0)
  route_table_id            = element(aws_route_table.private.*.id, count.index)
}

resource "aws_route" "add-routes-gcc-1" {
  count                     = var.create_peering ? length(var.availability_zones) : 0
  destination_cidr_block    = "192.168.12.0/22"
  vpc_peering_connection_id = element(aws_vpc_peering_connection.peer_gcc.*.id, 0)
  route_table_id            = element(aws_route_table.private.*.id, count.index)
}

resource "aws_route" "add-routes-gcc-2" {
  count                     = var.create_peering ? length(var.availability_zones) : 0
  destination_cidr_block    = "172.32.0.0/16"
  vpc_peering_connection_id = element(aws_vpc_peering_connection.peer_gcc.*.id, 0)
  route_table_id            = element(aws_route_table.private.*.id, count.index)
}

resource "aws_route" "add-routes-moe-1" {
  count                     = var.create_peering ? length(var.availability_zones) : 0
  destination_cidr_block    = "192.168.8.0/22"
  vpc_peering_connection_id = element(aws_vpc_peering_connection.peer_moe.*.id, 0)
  route_table_id            = element(aws_route_table.private.*.id, count.index)
}

resource "aws_route" "add-routes-moe-2" {
  count                     = var.create_peering ? length(var.availability_zones) : 0
  destination_cidr_block    = "172.33.0.0/16"
  vpc_peering_connection_id = element(aws_vpc_peering_connection.peer_moe.*.id, 0)
  route_table_id            = element(aws_route_table.private.*.id, count.index)
}

resource "aws_route" "add-routes-us-1" {
  count                     = var.create_peering ? length(var.availability_zones) : 0
  destination_cidr_block    = "192.168.0.0/22"
  vpc_peering_connection_id = element(aws_vpc_peering_connection.peer_us.*.id, 0)
  route_table_id            = element(aws_route_table.private.*.id, count.index)
}

resource "aws_route" "add-routes-us-2" {
  count                     = var.create_peering ? length(var.availability_zones) : 0
  destination_cidr_block    = "172.34.0.0/16"
  vpc_peering_connection_id = element(aws_vpc_peering_connection.peer_us.*.id, 0)
  route_table_id            = element(aws_route_table.private.*.id, count.index)
}

resource "aws_route" "add-routes-bigdata-1" {
  count                     = var.create_peering ? length(var.availability_zones) : 0
  destination_cidr_block    = "192.168.24.0/22"
  vpc_peering_connection_id = element(aws_vpc_peering_connection.peer_bigdata.*.id, 0)
  route_table_id            = element(aws_route_table.private.*.id, count.index)
}

resource "aws_route" "add-routes-fortinet" {
  count                     = var.create_peering ? length(var.availability_zones) : 0
  destination_cidr_block    = "10.10.10.0/24"
  vpc_peering_connection_id = element(aws_vpc_peering_connection.peer_fortinet.*.id, 0)
  route_table_id            = element(aws_route_table.private.*.id, count.index)
}

resource "aws_route" "add-routes-shared-1" {
  count                     = var.create_peering ? length(var.availability_zones) : 0
  destination_cidr_block    = "192.168.4.0/22"
  vpc_peering_connection_id = element(aws_vpc_peering_connection.peer_shared.*.id, 0)
  route_table_id            = element(aws_route_table.private.*.id, count.index)
}

resource "aws_route" "add-routes-shared-2" {
  count                     = var.create_peering ? length(var.availability_zones) : 0
  destination_cidr_block    = "172.36.0.0/16"
  vpc_peering_connection_id = element(aws_vpc_peering_connection.peer_shared.*.id, 0)
  route_table_id            = element(aws_route_table.private.*.id, count.index)
}