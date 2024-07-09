output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.vpc.id
}
output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value = aws_subnet.private.id
}


output "private_cidr" {
  description = "Private Subnet CIDR"
  value = aws_subnet.private.cidr_block
}