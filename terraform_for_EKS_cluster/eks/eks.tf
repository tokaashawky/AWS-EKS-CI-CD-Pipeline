# used in kubeconfig
data "aws_eks_cluster" "this" {
  name = aws_eks_cluster.main.name
}

data "aws_eks_cluster_auth" "this" {
  name = aws_eks_cluster.main.name
}

resource "aws_eks_cluster" "main" {
  name     = var.cluster_name_e
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = concat(var.public_subnet_ids, var.private_subnet_ids)
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_vpc_resource_controller_policy
  ]
}