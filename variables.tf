variable "bastion_enabled" {
  default = false
}

variable "bastion" {
  type    = "map"
  default = {}
}

variable "k8s_enabled" {
  default = false
}

variable "rds_enabled" {
  default = false
}

variable "elasticache_enabled" {
  default = false
}

variable "redshift_enabled" {
  default = false
}

variable "dms_enabled" {
  default = false
}

variable "cloudwatch_flow_log" {
  default = ""
}

variable "main_vars" {
  type = "map"
}

variable "network_vars" {
  type = "map"
}

# variable "domains" {
#   type = "map"
# }

variable "public_subnet_enable" {
  default = false
}
