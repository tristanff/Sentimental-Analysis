resource "aws_security_group" "compute_access" {
  name        = "compute_access"
  description = "Allow outbound traffic for the compute instance"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "compute_access"
  }
}