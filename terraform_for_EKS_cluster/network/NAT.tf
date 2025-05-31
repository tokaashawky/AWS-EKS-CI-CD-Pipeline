resource "aws_nat_gateway" "NAT" {
  allocation_id = aws_eip.EIP.id
  subnet_id     = aws_subnet.public[0].id

  depends_on = [aws_internet_gateway.IG]

  tags = {
    Name = "${var.cluster_name_m}-nat-gateway"
  }
}