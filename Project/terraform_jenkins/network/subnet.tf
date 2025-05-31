resource "aws_subnet" "PublicSubnet" {
  vpc_id            = aws_vpc.MyVPC.id
  cidr_block        = var.subnet_cidr
  availability_zone = "${var.region}a"
  tags = {
    Name = "PublicSubnet"
  }
}