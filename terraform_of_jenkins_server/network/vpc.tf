resource "aws_vpc" "MyVPC" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "MyVPC"
  }
}
