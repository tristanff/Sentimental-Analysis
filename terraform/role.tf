resource "aws_iam_role" "lab_role" {
  name               = "LabRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
    Name = "LabRole"
  }
}

output "lambda_execution_role_arn" {
  value = aws_iam_role.lab_role.arn
}
