output "vpc_id" {
  value = "${aws_vpc.default.id}"
}

output "private_subnet_ids" {
  value = ["${aws_subnet.private.*.id}"]
}

output "k8s_private_subnet_ids" {
  value = ["${aws_subnet.k8s_private.*.id}"]
}

output "private_routing_ids" {
  value = ["${aws_route_table.private.*.id}"]
}

output "public_subnet_ids" {
  value = ["${aws_subnet.public.*.id}"]
}

output "public_routing_ids" {
  value = ["${aws_route_table.public.*.id}"]
}

# output "private_ec_subnet_group" {
#   value = "${aws_elasticache_subnet_group.private_redis.name}"
# }

# output "public_ec_subnet_group" {
#   value = "${aws_elasticache_subnet_group.public_redis.name}"
# }

output "private_rds_subnet" {
  value = "${aws_db_subnet_group.default.*.name}"
}

# output "private_rs_subnet" {
#   value = "${aws_redshift_subnet_group.private_redshift.name}"
# }

# output "public_rs_subnet" {
#   value = "${aws_redshift_subnet_group.public_redshift.name}"
# }

# output "public_dms_subnet_id" {
#   value = "${aws_dms_replication_subnet_group.dms_subnet_group.id}"
# }

output "natgw_public_ip" {
  value = ["${aws_nat_gateway.natgw.*.public_ip}"]
}
