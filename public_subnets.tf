resource "aws_internet_gateway" "public" {
  vpc_id = "${aws_vpc.default.id}"
  tags   = "${merge(var.main_vars, map("type", "public"), map("system", "igw"), map("Name", format("igw_%s_%s", var.main_vars["application"], var.main_vars["env"])))}"
}

resource "aws_subnet" "public" {
  count             = "${length(var.network_vars["availability_zones"])}"
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${cidrsubnet(aws_vpc.default.cidr_block, 8, count.index + 60)}"
  availability_zone = "${element(var.network_vars["availability_zones"], count.index)}"
  tags              = "${merge(var.main_vars, map("system", "subnet"), map("type", "public"), map("Name", format("public_%s_%s", var.main_vars["application"], element(var.network_vars["availability_zones"], count.index))))}"

  lifecycle {
    create_before_destroy = true
  }

  map_public_ip_on_launch = true
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.default.id}"
  tags   = "${merge(var.main_vars, map("type", "public"), map("system", "routing"), map("Name", format("public_%s_%s", var.main_vars["application"], element(var.network_vars["availability_zones"], count.index))))}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.network_vars["availability_zones"])}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.public.*.id, count.index)}"

  lifecycle {
    create_before_destroy = true
  }
}

# Default GW
resource "aws_route" "public_defaultgw" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.public.id}"
}
