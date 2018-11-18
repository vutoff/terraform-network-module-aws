# RDS Subnet group
resource "aws_db_subnet_group" "default" {
  count      = "${var.rds_enabled}"
  name       = "private-rds-${var.main_vars["application"]}"
  subnet_ids = ["${aws_subnet.private.*.id}"]

  tags = "${merge(var.main_vars, map("type", "private"), map("system", "subnet"), map("type", "private"), map("Name", format("private_rds_%s_%s", var.main_vars["application"], element(var.network_vars["availability_zones"], count.index))))}"
}

# Elasticache Subnet group
resource "aws_elasticache_subnet_group" "private_redis" {
  count      = "${var.elasticache_enabled}"
  name       = "private-ec-${var.main_vars["application"]}"
  subnet_ids = ["${aws_subnet.private.*.id}"]
}

# Redshift Subnet group
resource "aws_redshift_subnet_group" "private_redshift" {
  count      = "${var.redshift_enabled}"
  name       = "private-rs-${var.main_vars["application"]}"
  subnet_ids = ["${aws_subnet.private.*.id}"]

  tags = "${merge(var.main_vars, map("type", "private"), map("system", "subnet"), map("type", "private"), map("Name", format("private_rs_%s_%s", var.main_vars["application"], element(var.network_vars["availability_zones"], count.index))))}"
}

# DMS Subnet group
resource "aws_dms_replication_subnet_group" "dms_subnet_group" {
  count                                = "${var.dms_enabled}"
  replication_subnet_group_description = "Subnet group needed for the DMS replication instances..!"
  replication_subnet_group_id          = "private-dms-${var.main_vars["application"]}"
  subnet_ids                           = ["${aws_subnet.private.*.id}"]
}
