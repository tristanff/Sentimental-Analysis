resource "aws_ecs_cluster" "compute_cluster" {
  name = "sentimental-analysis-cluster"
  tags = {
    Name = "sentimental-analysis-cluster"
  }

}

resource "aws_ecs_task_definition" "process_raw_tweets" {
  family             = "process-raw-tweets"
  network_mode       = "awsvpc"
  execution_role_arn = "arn:aws:iam::${var.account_id}:role/LabRole"
  task_role_arn      = "arn:aws:iam::${var.account_id}:role/LabRole"
  cpu                = "4096"
  memory             = "8192"
  container_definitions = jsonencode([
    {
      name        = "compute-instance"
      image       = "${var.account_id}.dkr.ecr.${var.region}.amazonaws.com/sentimental-analysis:latest"
      cpu         = 4096
      memory      = 8192
      essential   = true
      environment = [{ name : "API_URL", value : var.api_gateway_url }]
    }
  ])

  requires_compatibilities = ["FARGATE"]

  tags = {}
}

resource "aws_scheduler_schedule" "cron" {
  name       = "process-tweets-schedule"
  group_name = "default"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = "cron(0 0/8 * * ? *)"

  target {
    arn      = aws_ecs_cluster.compute_cluster.arn
    role_arn = "arn:aws:iam::${var.account_id}:role/LabRole"

    ecs_parameters {
      # trimming the revision suffix here so that schedule always uses latest revision
      task_definition_arn = trimsuffix(aws_ecs_task_definition.process_raw_tweets.arn, ":${aws_ecs_task_definition.process_raw_tweets.revision}")
      launch_type         = "FARGATE"

      network_configuration {
        subnets = var.subnet_ids
      }
    }

    retry_policy {
      maximum_event_age_in_seconds = 300
      maximum_retry_attempts       = 10
    }
  }
}