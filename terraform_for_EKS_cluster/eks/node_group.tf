resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = var.node_group_name_e
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = var.desired_capacity_e
    max_size     = var.max_capacity_e
    min_size     = var.min_capacity_e
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_worker_policy,
    aws_iam_role_policy_attachment.node_registry_read_only_policy,
    aws_iam_role_policy_attachment.node_cni_policy,
    aws_eks_cluster.main
  ]

  tags = {
    Name = var.node_group_name_e
  }
}