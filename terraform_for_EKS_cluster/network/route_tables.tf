resource "aws_route_table" "public" {
  vpc_id = aws_vpc.MyVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IG.id
  }
  tags = {
    Name = "${var.cluster_name_m}-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_m)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.MyVPC.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT.id
  }
  tags = {
    Name = "${var.cluster_name_m}-private-rt"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets_m)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
