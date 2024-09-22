output "vpc_id" {
  description = "vpc id"
  value = aws_vpc.main.id
}

output "public_subnets" {
  description = "public_subnets"
  value = aws_subnet.public_subnets[*].id
  
}

output "privet_subnets" {
  description = "privet_subnets"
  value = aws_subnet.private_subnets[*].id
  
}

output "sg" {
  description = "public_sg"
  value = aws_security_group.public_sg.id
}