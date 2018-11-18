resource "aws_eip" "natgw_ip" {
  count = "${length(var.network_vars["availability_zones"])}"
  vpc   = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "natgw" {
  count         = "${length(var.network_vars["availability_zones"])}"
  allocation_id = "${aws_eip.natgw_ip.*.id[count.index]}"
  subnet_id     = "${aws_subnet.public.*.id[count.index]}"
  tags          = "${merge(var.main_vars, map("system", "natgw"))}"
}

resource "aws_subnet" "private" {
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${cidrsubnet(aws_vpc.default.cidr_block, 8, count.index + 50)}"
  availability_zone = "${element(var.network_vars["availability_zones"], count.index)}"
  count             = "${length(var.network_vars["availability_zones"])}"

  tags = "${merge(var.main_vars, map("type", "private"), map("system", "subnet"), map("type", "private"), map("Name", format("private_%s_%s", var.main_vars["application"], element(var.network_vars["availability_zones"], count.index))))}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table" "private" {
  count  = "${length(var.network_vars["availability_zones"])}"
  vpc_id = "${aws_vpc.default.id}"
  tags   = "${merge(var.main_vars, map("type", "private"), map("system", "routing"), map("Name", format("private_%s_%s",var.main_vars["application"], element(var.network_vars["availability_zones"], count.index))))}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table_association" "private" {
  count          = "${length(var.network_vars["availability_zones"])}"
  subnet_id      = "${aws_subnet.private.*.id[count.index]}"
  route_table_id = "${aws_route_table.private.*.id[count.index]}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route" "private_defaultgw" {
  count                  = "${length(var.network_vars["availability_zones"])}"
  route_table_id         = "${aws_route_table.private.*.id[count.index]}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.natgw.*.id[count.index]}"
}
