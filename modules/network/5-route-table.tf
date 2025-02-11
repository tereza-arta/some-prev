resource "aws_route_table" "for_pub_sub" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.default_gateway
    gateway_id = aws_internet_gateway.igw.id 
  }

  tags = {
    Name = var.rt_tag
  }
}

resource "aws_route_table" "for_priv_sub" {
  count = var.az_cnt
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.default_gateway
    nat_gateway_id = element(aws_nat_gateway.nat.*.id, count.index)
  }
}

resource "aws_route_table_association" "pub_sub_assoc" {
  count = var.az_cnt
  subnet_id = element(aws_subnet.pub[*].id, count.index)
  route_table_id = aws_route_table.for_pub_sub.id
}

resource "aws_route_table_association" "priv_sub_assoc" {
  count = var.az_cnt
  subnet_id = element(aws_subnet.priv[*].id, count.index)
  route_table_id = aws_route_table.for_priv_sub[count.index].id
}
