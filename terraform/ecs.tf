# Define VPC ID
variable "vpc_id" {
  description = "ID of the VPC where ECS cluster will be created"
}

# ECS Cluster
resource "aws_ecs_cluster" "prod_cluster" {
  name = "ProdCluster"

  capacity_providers = [
    "FARGATE",
    "FARGATE_SPOT"
  ]

  # Configure VPC
  vpc_configuration {
    subnet_ids         = [var.subnet_ids]  # Specify your subnet IDs
    security_group_ids = [var.security_group_ids]  # Specify your security group IDs
  }
}

# ECS Service Discovery Namespace
resource "aws_service_discovery_private_dns_namespace" "service_discovery_namespace" {
  name = "ns-ghek2yidlflo7xcc",
  vpc = ""
}

# ECS Service Connect Defaults
resource "aws_ecs_service_discovery" "service_connect_defaults" {
  name               = "service_connect_defaults"
  namespace_id       = aws_service_discovery_private_dns_namespace.service_discovery_namespace.id
  dns_service_name   = "ProdCluster"
}