



resource "aws_ecs_task_definition" "process_raw_tweets" {
  family                   = "ProcessRawTweets"
  network_mode             = "awsvpc"
  execution_role_arn       = "arn:aws:iam::052963506097:role/LabRole"
  task_role_arn            = "arn:aws:iam::052963506097:role/LabRole"
  cpu                      = "4096"
  memory                   = "8192"
  container_definitions = jsonencode([
    {
      name      = "ComputeInstance"
      image     = "058264505049/ComputeAMI"
      cpu       = 4096
      memory    = 8192
      essential = true
    }
  ])

  requires_compatibilities = ["FARGATE"]

  tags = {}
}

