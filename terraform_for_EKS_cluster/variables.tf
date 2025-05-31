variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "public_subnets" {
  description = "Public subnet CIDRs"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private subnet CIDRs"
  type        = list(string)
}

variable "cluster_name" {
  description = "EKS Cluster name"
  type        = string
}

variable "node_group_name" {
  description = "EKS node group name"
  type        = string
}

variable "desired_capacity" {
  description = "Node group desired capacity"
  type        = number
}

variable "max_capacity" {
  description = "Node group max capacity"
  type        = number
}

variable "min_capacity" {
  description = "Node group min capacity"
  type        = number
}
