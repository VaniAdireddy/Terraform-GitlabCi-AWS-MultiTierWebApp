# This is outputs file for the Network_VPC module 

output "main_vpc_id" {
  value = aws_vpc.mainvpc.id
}

output "private_rt_id" {
  value = aws_route_table.PrivateRT
}

output "public_rt_id" {
  value = aws_route_table.PublicRT
}

output "private_subnet_1" {
  value = aws_subnet.PrivateSubnet1.id
}

output "private_subnet_2" {
  value = aws_subnet.PrivateSubnet2.id
}

output "public_subnet_1" {
  value = aws_subnet.PublicSubnet1.id
}

output "public_subnet_2" {
  value = aws_subnet.PublicSubnet2.id
}

output "internal_sg_id" {
  value = aws_security_group.FromALBOnly.id
}

output "external_sg_id" {
  value = aws_security_group.AllowPublic.id
}