resource "aws_internet_gateway" "IG" {
  vpc_id = aws_vpc.MyVPC.id

  tags = {
    Name = "${var.cluster_name_m}-IG"
  }
}