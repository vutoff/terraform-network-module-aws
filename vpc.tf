resource "aws_vpc" "default" {
  cidr_block           = "${element(var.network_vars["vpc_cidr"], 0)}"
  enable_dns_hostnames = true
  tags                 = "${merge(var.main_vars, map("Name", format("vpc-%s-%s", var.main_vars["application"], var.main_vars["env"])))}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id       = "${aws_vpc.default.id}"
  service_name = "com.amazonaws.${var.main_vars["region"]}.s3"
}

resource "aws_vpc_dhcp_options" "default" {
  domain_name         = "${var.main_vars["region"]}.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]
  tags                = "${merge(var.main_vars, map("Name", format("vpc-%s-%s", var.main_vars["application"], var.main_vars["env"])))}"
}

resource "aws_vpc_dhcp_options_association" "default" {
  vpc_id          = "${aws_vpc.default.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.default.id}"
}

# Setup flow logs
resource "aws_flow_log" "flow_logs" {
  count          = "${var.cloudwatch_flow_log != "" ? 1 : 0}"
  log_group_name = "${var.cloudwatch_flow_log}"
  iam_role_arn   = "${aws_iam_role.flow_logs.arn}"
  vpc_id         = "${aws_vpc.default.id}"
  traffic_type   = "ALL"
}
