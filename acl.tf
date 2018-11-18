resource "aws_network_acl" "acl" {
  vpc_id     = "${aws_vpc.default.id}"
  subnet_ids = ["${concat(aws_subnet.public.*.id, aws_subnet.private.*.id)}"]

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = "${merge(var.main_vars, map("system", "network_acl"), map("Name", format(var.main_vars["application"],"_all")))}"
}
