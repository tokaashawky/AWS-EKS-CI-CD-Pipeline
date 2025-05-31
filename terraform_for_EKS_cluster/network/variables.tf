variable "vpc_cidr_m" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets_m" {
  description = "Public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_subnets_m" {
  description = "Private subnet CIDRs"
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.3.0/24"]
}

variable "cluster_name_m" {
  description = "EKS Cluster name"
  type        = string
  default     = "my-eks-cluster"
}

