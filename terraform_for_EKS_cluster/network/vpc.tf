resource "aws_vpc" "MyVPC" {
  cidr_block = var.vpc_cidr_m

  tags = {
    Name = "${var.cluster_name_m}-MyVPC"
  }
}