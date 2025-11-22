output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "instance_sg_id" {
  value = aws_security_group.instance.id
}

output "vpc_id" {
value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}