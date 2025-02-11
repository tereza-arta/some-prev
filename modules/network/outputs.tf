output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_arn" {
  value = aws_vpc.vpc.arn
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "igw_arn" {
  value = aws_internet_gateway.igw.arn
}

output "account_owner_id" {
  value = aws_internet_gateway.igw.owner_id
}

output "pub_sub_id" {
  value = aws_subnet.pub.*.id
}

output "priv_sub_id" {
  value = aws_subnet.priv.*.id
}

output "eip_id" {
  value = aws_eip.eip.*.id
}

output "eip_pub_ip" {
  value = aws_eip.eip.*.public_ip
}

output "nat_id" {
  value = aws_nat_gateway.nat.*.id
}

output "pub_rt_id" {
  value = aws_route_table.for_pub_sub.id
}

output "priv_rt_id" {
  value = aws_route_table.for_priv_sub.*.id
}


output "pub_rt_assoc_id" {
  value = aws_route_table_association.pub_sub_assoc.*.id
}

output "priv_rt_assoc_id" {
  value = aws_route_table_association.priv_sub_assoc.*.id
}

output "lb_sg_id" {
  value = aws_security_group.for_lb.id
}

output "ecs_sg_id" {
  value = aws_security_group.for_ecs.*.id
}

