variable "cluster_name_e" {
  description = "EKS Cluster name"
  type        = string
  default     = "my-eks-cluster"
}

variable "node_group_name_e" {
  description = "EKS node group name"
  type        = string
  default     = "my-eks-nodes"
}

variable "desired_capacity_e" {
  description = "Node group desired capacity"
  type        = number
  default     = 2
}

variable "max_capacity_e" {
  description = "Node group max capacity"
  type        = number
  default     = 3
}

variable "min_capacity_e" {
  description = "Node group min capacity"
  type        = number
  default     = 1
}
variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnet IDs"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}