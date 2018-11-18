resource "aws_iam_role" "flow_logs" {
  count = "${var.cloudwatch_flow_log != "" ? 1 : 0}"
  name  = "fl-${var.main_vars["application"]}-${var.main_vars["env"]}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "flow_logs" {
  count = "${var.cloudwatch_flow_log != "" ? 1 : 0}"
  name  = "test_policy"
  role  = "${aws_iam_role.flow_logs.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
