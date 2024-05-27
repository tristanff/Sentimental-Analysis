resource "aws_ecr_repository" "sentimental-analysis-ecr" {
  name = "sentimental-analysis-ecr"
  tags = {
    Name = "sentimental-analysis-ecr"
  }
}

resource "aws_ecs_cluster" "compute_cluster" {
  name = "sentimental-analysis-cluster"
  tags = {
    Name = "sentimental-analysis-cluster"
  }

}

resource "aws_ecs_task_definition" "process_raw_tweets" {
  family             = "ProcessRawTweets"
  network_mode       = "awsvpc"
  execution_role_arn = var.lab_role_arn
  task_role_arn      = var.lab_role_arn
  cpu                = "4096"
  memory             = "8192"
  container_definitions = jsonencode([
    {
      name        = "ComputeInstance"
      image       = var.container_image_url
      cpu         = 4096
      memory      = 8192
      essential   = true
      environment = [{ name : "API_URL", value : "https://${aws_api_gateway_rest_api.sentimental_api.id}.execute-api.us-east-1.amazonaws.com/${aws_api_gateway_deployment.sentimental_api_deployment.stage_name}" }]
    }
  ])

  requires_compatibilities = ["FARGATE"]

  tags = {}
}