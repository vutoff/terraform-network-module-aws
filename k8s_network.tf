# Subnets
resource "aws_subnet" "k8s_private" {
  count             = "${var.k8s_enabled != 0 ? length(var.network_vars["availability_zones"]) : 0}"
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${cidrsubnet(aws_vpc.default.cidr_block, 4, count.index)}"
  availability_zone = "${element(var.network_vars["availability_zones"], count.index)}"

  tags = "${merge(
    var.main_vars, map("type", "private"),
    map("system", "subnet"),
    map("purpose", "k8s"),
    map("Name", format("k8s_private_%s_%s", var.main_vars["application"], element(var.network_vars["availability_zones"], count.index))))}"

  lifecycle {
    create_before_destroy = true
  }
}

# Routing
resource "aws_route_table_association" "k8s_private" {
  count          = "${var.k8s_enabled != 0 ? length(var.network_vars["availability_zones"]) : 0}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"

  lifecycle {
    create_before_destroy = true
  }
}
