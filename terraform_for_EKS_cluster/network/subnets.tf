data "aws_availability_zones" "available" {}
resource "aws_subnet" "public" {
  count             = length(var.public_subnets_m)
  vpc_id            = aws_vpc.MyVPC.id
  cidr_block        = var.public_subnets_m[count.index]
  map_public_ip_on_launch = true
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "${var.cluster_name_m}-public-subnet-${count.index}"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnets_m)
  vpc_id            = aws_vpc.MyVPC.id
  cidr_block        = var.private_subnets_m[count.index]
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "${var.cluster_name_m}-private-subnet-${count.index}"
  }
}