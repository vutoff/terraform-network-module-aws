data "aws_ami" "bastion" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["*ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  ami_id                 = "${lookup(var.bastion, "ami_id", data.aws_ami.bastion.id)}"
  instance_type          = "${lookup(var.bastion, "instance_type", "t3.medium")}"
  termination_protection = "${lookup(var.bastion, "termination_protection", false)}"
  monitoring             = "${lookup(var.bastion, "monitoring", false)}"
  key_name               = "${var.bastion["key_name"]}"
}

resource "aws_eip" "main" {
  count    = "${var.bastion_enabled}"
  instance = "${aws_instance.main.*.id[count.index]}"
  vpc      = true
}

resource "aws_instance" "main" {
  count                   = "${var.bastion_enabled}"
  ami                     = "${local.ami_id}"
  instance_type           = "${local.instance_type}"
  subnet_id               = "${element(aws_subnet.public.*.id, count.index)}"
  key_name                = "${local.key_name}"
  vpc_security_group_ids  = ["${aws_security_group.bastion.id}"]
  iam_instance_profile    = "${aws_iam_instance_profile.generic.id}"
  disable_api_termination = "${local.termination_protection}"
  monitoring              = "${local.monitoring}"
  source_dest_check       = true

  root_block_device = {
    volume_type = "gp2"
    volume_size = "15"
  }

  lifecycle {
    ignore_changes        = ["volume", "ami", "user_data", "ebs_optimized", "tags"]
    create_before_destroy = true
  }

  credit_specification {
    cpu_credits = "${lookup(var.bastion, "cpu_credits", "standard")}"
  }
}

resource "aws_iam_instance_profile" "generic" {
  name_prefix = "${var.main_vars["application"]}-bastion-"
  role        = "${aws_iam_role.generic.name}"

  # The below lines are due to issue https://github.com/hashicorp/terraform/issues/1885
  provisioner "local-exec" {
    command = "sleep 90"
  }
}

resource "aws_iam_role" "generic" {
  name_prefix = "${var.main_vars["application"]}-bastion-"
  path        = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_security_group" "bastion" {
  name        = "${var.main_vars["application"]}-bastion-sg"
  description = "Allow inbound SSH traffic to Bastion Host"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["${split(",", var.bastion["allowed_ips"])}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
