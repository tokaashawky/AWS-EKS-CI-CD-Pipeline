data "aws_ami" "ubuntu_ami" {
  most_recent      = true
   owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
resource "aws_instance" "app-server" {
  ami                         = data.aws_ami.ubuntu_ami.id
  instance_type               = var.instance_type_m
  key_name                    = aws_key_pair.public_key_pair.key_name
  subnet_id                   = var.PublicSubnet_m
  vpc_security_group_ids      = [var.ssh_jenkins_sg_m]
  availability_zone           = "${var.region}a"
  associate_public_ip_address = true
  tags = {
    Name = "app-server"
  }
}
