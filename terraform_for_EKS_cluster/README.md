# AWS EKS Cluster Terraform Module

This Terraform project provisions a highly available and scalable **Amazon EKS (Elastic Kubernetes Service)** cluster with associated networking infrastructure on AWS.

---

## Features

- Creates a **VPC** with public and private subnets
- Provisions an **Internet Gateway** and **NAT Gateway** for outbound internet access
- Sets up **Route Tables** for public and private subnets
- Deploys an **EKS Cluster** control plane with proper IAM roles and policies
- Creates an **EKS Managed Node Group** within private subnets with auto-scaling configuration
- Outputs key cluster information such as cluster name and API endpoint
- Backend state stored in an **S3 bucket** with state locking enabled

---

## Architecture Overview

```text
+-----------------------+
|       VPC             |
|  +----------------+   |
|  | Public Subnets  |---|-- Internet Gateway --> Internet
|  +----------------+   |
|                       |
|  +----------------+   |
|  | Private Subnets |---|-- NAT Gateway --> Internet
|  +----------------+   |
+-----------------------+

EKS Control Plane deployed in VPC

EKS Node Group (worker nodes) launched in Private Subnets
```

## Prerequisites

- Terraform >= 1.0
- AWS CLI configured with appropriate credentials and region
- AWS account with sufficient permissions to create resources

## Variables

| Name               | Description                       | Type           | Default                          |
| ------------------ | --------------------------------- | -------------- | -------------------------------- |
| `aws_region`       | AWS region                        | `string`       | e.g. `us-east-1`                 |
| `vpc_cidr`         | CIDR block for the VPC            | `string`       | `"10.0.0.0/16"`                  |
| `public_subnets`   | List of CIDRs for public subnets  | `list(string)` | `["10.0.0.0/24", "10.0.1.0/24"]` |
| `private_subnets`  | List of CIDRs for private subnets | `list(string)` | `["10.0.2.0/24", "10.0.3.0/24"]` |
| `cluster_name`     | Name of the EKS cluster           | `string`       | `"my-eks-cluster"`               |
| `node_group_name`  | Name for the EKS node group       | `string`       | `"my-eks-nodes"`                 |
| `desired_capacity` | Desired node count                | `number`       | `2`                              |
| `max_capacity`     | Maximum node count                | `number`       | `3`                              |
| `min_capacity`     | Minimum node count                | `number`       | `1`                              |

## Usage

```bash
git clone <repo-url>
cd <repo-directory>

terraform init
terraform plan
terraform apply
```

## Outputs

| Name                   | Description                                 |
| ---------------------- | ------------------------------------------- |
| `eks_cluster_name`     | The EKS cluster name                        |
| `eks_cluster_endpoint` | The API server endpoint for the EKS cluster |
| `vpc_id`               | VPC ID created                              |
| `public_subnet_ids`    | List of public subnet IDs                   |
| `private_subnet_ids`   | List of private subnet IDs                  |

## IAM Roles and Policies
- **EKS Cluster Role**: Grants permissions required by the EKS control plane

- **EKS Node Group Role**: Permissions for EC2 worker nodes to communicate with EKS and pull container images

## Backend Configuration

Terraform state is stored remotely in an S3 bucket with state locking enabled to prevent concurrent operations:

```bash
terraform {
  backend "s3" {
    bucket       = "aws-terraform-backend-statefile"
    key          = "EKS_Infrastructure/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}
```

## Notes

- Node groups run in private subnets for security best practices.
- Public subnets are configured to assign public IPs on launch for the NAT gateway and other resources.
- Customize the variables to fit your network design and cluster size requirements.

## Author:
Toka Shawky