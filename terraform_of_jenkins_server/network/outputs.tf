output PublicSubnet {
  value       = aws_subnet.PublicSubnet.id
}

output vpc_id {
  value       = aws_vpc.MyVPC.id
}

output ssh_jenkins_sg {
  value       = aws_security_group.ssh_jenkins_sg.id
}
