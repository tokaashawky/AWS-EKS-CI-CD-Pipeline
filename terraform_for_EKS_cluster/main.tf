module "network" {
    source = "./network"
    vpc_cidr_m = var.vpc_cidr
    public_subnets_m = var.public_subnets
    private_subnets_m = var.private_subnets
    cluster_name_m = var.cluster_name
}
module "eks" {
    source = "./eks"
    cluster_name_e = var.cluster_name
    node_group_name_e = var.node_group_name
    desired_capacity_e = var.desired_capacity
    max_capacity_e = var.max_capacity
    min_capacity_e = var.min_capacity
    private_subnet_ids = module.network.private_subnet_ids
    public_subnet_ids  = module.network.public_subnet_ids
    vpc_id             = module.network.vpc_id
}