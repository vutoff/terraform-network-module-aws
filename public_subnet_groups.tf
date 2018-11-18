# Redshift Subnet group
resource "aws_redshift_subnet_group" "public_redshift" {
  count      = "${var.redshift_enabled}"
  name       = "public-rs-${var.main_vars["application"]}"
  subnet_ids = ["${aws_subnet.public.*.id}"]

  tags = "${merge(var.main_vars, map("system", "subnet"), map("type", "public"), map("Name", format("public_rs_%s_%s", var.main_vars["application"], element(var.network_vars["availability_zones"], count.index))))}"
}

resource "aws_elasticache_subnet_group" "public_redis" {
  count      = "${var.elasticache_enabled}"
  name       = "public-ec-${var.main_vars["application"]}"
  subnet_ids = ["${aws_subnet.public.*.id}"]
}
