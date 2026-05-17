output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  value = [for s in aws_subnet.public_subnet: s.id]
}

output "private_subnet_ids" {
  value = [for s in aws_subnet.private_subnet: s.id]
}

output "public_subnet_map" {
  value = {for az, subnet in aws_subnet.public_subnet: az=> subnet.id}
}