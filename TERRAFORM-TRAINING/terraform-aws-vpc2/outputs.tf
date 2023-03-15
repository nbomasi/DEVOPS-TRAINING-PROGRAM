output "vpc_id" {
  value = aws_vpc.mtc_vpc.id

}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.mtc_rds.*.name
}

output "db_security_group_ids" {
  value = [aws_security_group.rds_sg["private"].id]
}

output "vpc_public_subnets" {
  #value = aws_subnet.mtc_public_subnet.id[count.index]
  value = aws_subnet.mtc_public_subnet.*.id
  #value = [for subnet in aws_subnet.mtc_public_subnet: subnet.id]
}

output "vpc_public_sg" {
  value = [aws_security_group.mtc_sg["public"].id] # the external bracket is used because we are using DYNAMIC ASSIGNMENT
}