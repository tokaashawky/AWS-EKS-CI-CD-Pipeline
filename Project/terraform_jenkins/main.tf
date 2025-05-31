module "mynetwork" {
    source = "./network"
    vpc_cidr = var.vpc_cidr_block
    region = var.region
    subnet_cidr = var.subnet_cidr_block
}
module "mycompute" {
    source = "./compute"
    instance_type_m = var.instance_type
    region = var.region
    ssh_jenkins_sg_m= module.mynetwork.ssh_jenkins_sg
    PublicSubnet_m= module.mynetwork.PublicSubnet
}