



resource "aws_ecs_task_definition" "process_raw_tweets" {
  family                   = "ProcessRawTweets"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.lab_role.arn
  task_role_arn            = aws_iam_role.lab_role.arn
  cpu                      = "4096"
  memory                   = "8192"
  container_definitions = jsonencode([
    {
      name      = "ComputeInstance"
      image     = "058264505049/ComputeAMI"
      cpu       = 0
      memory    = 0
      essential = true
    }
  ])

  requires_compatibilities = ["FARGATE"]

  tags = {}
}

