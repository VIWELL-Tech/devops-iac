resource "aws_subnet" "s" { #Subnet creation for gcc
  count = "${var.create-subnets ? length(var.cidr_block) : 0}"
  vpc_id     = "${var.vpc_id}"
  cidr_block = "${var.cidr_block[count.index]}"
  availability_zone = "${var.availability_zone[count.index]}"
  tags = "${merge(
    map(
     "Name", "${var.subnet-type}-subnet-${var.environment}-${var.availability_zone[count.index]}" ),
     var.subnet_tags
    )
  }"
}

resource "aws_route_table" "r" {

  count =  "${var.create-route-table ? 1:0}"
  vpc_id = "${var.vpc_id}"
  route = "${var.routes}"
  tags = "${merge(
    map(
     "Name", "route-table-${var.environment}-${count.index + 1}" ),
     var.tags
    )
  }"
}

resource "aws_route_table_association" "a" {
  count = "${var.associate-subnet ? var.subnet_count : 0}"
  subnet_id      = "${var.subnet_id[count.index]}"
  route_table_id = "${var.route_table_id}"
}


