resource "aws_ecs_cluster" "compute_cluster" {
  name = "sentimental-analysis-cluster"
  tags = {
    Name = "sentimental-analysis-cluster"
  }

}

resource "aws_ecs_task_definition" "process_raw_tweets" {
  family             = "process-raw-tweets"
  network_mode       = "awsvpc"
  execution_role_arn = var.lab_role_arn
  task_role_arn      = var.lab_role_arn
  cpu                = "4096"
  memory             = "8192"
  container_definitions = jsonencode([
    {
      name        = "compute-instance"
      image       = var.container_image_url
      cpu         = 4096
      memory      = 8192
      essential   = true
      environment = [{ name : "API_URL", value : var.api_gateway_url }]
    }
  ])

  requires_compatibilities = ["FARGATE"]

  tags = {}
}