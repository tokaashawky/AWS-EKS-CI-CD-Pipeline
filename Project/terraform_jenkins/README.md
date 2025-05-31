# AWS Infrastructure with Terraform — VPC, Networking, and Compute Resources

## Overview

This Terraform project automates the provisioning of a secure and scalable AWS infrastructure, including:

- A custom VPC with public subnets, internet gateway, and route tables
- Security groups tailored for SSH, HTTP, and Jenkins access
- Compute resources running Ubuntu EC2 instances with dynamically fetched AMIs
- SSH key pair management integrated with AWS Secrets Manager
- Remote state management via S3 backend

The infrastructure is modularized for easy maintenance, reuse, and scalability, split into **network** and **compute** modules.

---


---

## Modules

### 1. Network Module (`./network`)

This module provisions:

- **VPC:** Custom CIDR block defined by `vpc_cidr_block` (e.g., `10.0.0.0/16`)
- **Public Subnet:** Single subnet with CIDR block `subnet_cidr_block` (e.g., `10.0.10.0/24`) in availability zone `${region}a`
- **Internet Gateway:** Provides outbound internet access for resources in the public subnet
- **Route Table & Association:** Routes 0.0.0.0/0 traffic to the Internet Gateway for the public subnet
- **Security Group (`ssh_jenkins_sg`):** Allows inbound access on ports 22 (SSH), 80 (HTTP), and 8080 (Jenkins) from anywhere

**Inputs:**

| Variable           | Type   | Description                    |
|--------------------|--------|-------------------------------|
| `vpc_cidr_block`   | string | CIDR block for the VPC         |
| `subnet_cidr_block`| string | CIDR block for the public subnet|
| `region`           | string | AWS region (e.g., us-east-1)   |

**Outputs:**

| Output            | Description                  |
|-------------------|------------------------------|
| `vpc_id`          | ID of the created VPC         |
| `PublicSubnet`    | ID of the public subnet       |
| `ssh_jenkins_sg`  | ID of the security group      |

---

### 2. Compute Module (`./compute`)

This module provisions:

- **TLS RSA Key Pair:** Generates a 4096-bit RSA key pair
- **AWS Key Pair Resource:** Uses the public key to create a key pair for EC2
- **Secrets Manager Secrets:** Stores the private and public keys securely
- **EC2 Instance:** Ubuntu 22.04 LTS AMI automatically selected (most recent, HVM, EBS backed), running in the public subnet
- **Instance Configuration:** Uses provided instance type and security group allowing SSH and HTTP access

**Inputs:**

| Variable            | Type   | Description                         |
|---------------------|--------|------------------------------------|
| `instance_type_m`   | string | EC2 instance type (e.g., `t2.micro`)|
| `region`            | string | AWS region                        |
| `ssh_jenkins_sg_m`  | string | Security group ID for SSH & HTTP  |
| `PublicSubnet_m`    | string | Public subnet ID                  |

**Outputs:**

| Output            | Description                     |
|-------------------|---------------------------------|
| `ec2_public_ip`   | Public IP address of the EC2 instance |

---

## Terraform Backend

The remote backend is configured to use an **S3 bucket** for state file storage to enable collaboration and state locking.

```hcl
terraform {
  backend "s3" {
    bucket         = "aws-terraform-backend-statefile"
    key            = "jenkins_infra/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile   = true
  }
}
```

## Usage

### Prerequisites

- AWS CLI configured with appropriate permissions
- Terraform installed (version 1.0 or later recommended)
- AWS S3 bucket created for remote state storage

### Steps to Deploy

1. **Clone the repository**

```bash
git clone <repository-url>
cd <repository-directory>
```

## Initialize Terraform

Run the following command to initialize Terraform. This downloads the necessary provider plugins and configures the remote backend to store your state file in S3.

```bash
terraform init
```

## Plan Infrastructure

Before applying changes, it’s good practice to preview them with: This will show what Terraform intends to create, update, or delete.

```bash
terraform plan -out=tfplan
```

## Apply Infrastructure

Apply the changes and provision your AWS resources:

```bash
terraform apply tfplan
```

Or apply directly without saving the plan:

```bash
terraform apply -auto-approve
```

## Retrieve Outputs

Once the infrastructure is created, retrieve key output values:

```bash
terraform output
```

## Connect to EC2 Instance

Retrieve the private SSH key from AWS Secrets Manager:

```bash
aws secretsmanager get-secret-value --secret-id private_key --query SecretString --output text > private_key.pem
chmod 400 private_key.pem
```

SSH into your EC2 instance:

```bash
ssh -i private_key.pem ubuntu@<ec2_public_ip>
```

Replace <ec2_public_ip> with the output value from Terraform.

## Variables

| Variable Name       | Description                        | Type   | Default          |
| ------------------- | ---------------------------------- | ------ | ---------------- |
| `vpc_cidr_block`    | CIDR block for the VPC             | string | `"10.0.0.0/16"`  |
| `subnet_cidr_block` | CIDR block for the public subnet   | string | `"10.0.10.0/24"` |
| `region`            | AWS Region (e.g., us-east-1)       | string | `"us-east-1"`    |
| `instance_type`     | EC2 instance type (e.g., t2.micro) | string | `"t2.micro"`     |

## Outputs

| Output Name      | Description                           |
| ---------------- | ------------------------------------- |
| `vpc_id`         | The ID of the created VPC             |
| `PublicSubnet`   | The ID of the public subnet           |
| `ssh_jenkins_sg` | Security group allowing SSH and HTTP  |
| `ec2_public_ip`  | Public IP address of the EC2 instance |


##  Support and Contributions
Feel free to submit issues or pull requests. Contributions are welcome!

## Author
Toka Shawky :]