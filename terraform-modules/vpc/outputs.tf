output "subnets_id" {
  value = "${aws_subnet.s.*.id}"
}

output "route-table-id" {
  value = "${aws_route_table.r.*.id}"
}