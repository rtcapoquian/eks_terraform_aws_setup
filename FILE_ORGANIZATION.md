# EKS Infrastructure - File Organization

## Overview

This EKS infrastructure has been refactored from a single large `main.tf` file into logical, readable components while maintaining all resources as native AWS resources (no modules).

## File Structure

### Core Configuration Files

- **`main.tf`** - Documentation and overview of the infrastructure
- **`providers.tf`** - AWS provider configuration
- **`variables.tf`** - Input variables for customization
- **`terraform.tfvars`** - Variable values for the environment
- **`outputs.tf`** - Output values from the infrastructure

### Infrastructure Components

- **`networking.tf`** - Network infrastructure

  - Data sources (availability zones, caller identity, partition)
  - VPC with DNS enabled
  - Public and private subnets across 2 AZs
  - Internet Gateway and NAT Gateway
  - Elastic IP for NAT Gateway
  - Route tables and associations

- **`eks-cluster.tf`** - EKS cluster and security

  - EKS cluster IAM role and policies
  - EKS cluster security group and rules
  - EKS cluster configuration

- **`node-groups.tf`** - Worker nodes
  - Node group IAM role and policies
  - On-demand node group configuration
  - Spot instance node group configuration

## Resource Distribution

### networking.tf (12 resources)

- `data.aws_availability_zones.available`
- `data.aws_caller_identity.current`
- `data.aws_partition.current`
- `aws_vpc.main`
- `aws_internet_gateway.main`
- `aws_subnet.public[2]`
- `aws_subnet.private[2]`
- `aws_eip.nat`
- `aws_nat_gateway.main`
- `aws_route_table.public`
- `aws_route_table.private`
- `aws_route_table_association.public[2]`
- `aws_route_table_association.private[2]`

### eks-cluster.tf (5 resources)

- `aws_iam_role.cluster`
- `aws_iam_role_policy_attachment.cluster_policy`
- `aws_security_group.cluster`
- `aws_security_group_rule.cluster_ingress_workstation`
- `aws_eks_cluster.main`

### node-groups.tf (8 resources)

- `aws_iam_role.node_group`
- `aws_iam_role_policy_attachment.node_group_worker_policy`
- `aws_iam_role_policy_attachment.node_group_cni_policy`
- `aws_iam_role_policy_attachment.node_group_registry_policy`
- `aws_eks_node_group.main`
- `aws_eks_node_group.spot`

## Benefits of This Organization

1. **Logical Separation**: Resources are grouped by function and purpose
2. **Improved Readability**: Each file focuses on a specific infrastructure layer
3. **Easier Maintenance**: Changes to specific components are isolated
4. **Better Understanding**: Clear separation helps with learning and debugging
5. **Native Resources**: All AWS resources are defined directly without external modules
6. **State Preservation**: No changes to resource addresses, maintaining existing state

## Cost Optimization Features

- **Single NAT Gateway**: Reduces costs while maintaining private subnet connectivity
- **t3.small Instances**: Right-sized for learning environment
- **Spot Instances**: Significant cost reduction for non-critical workloads
- **Minimal Node Groups**: Optimized scaling configuration

## Usage

All Terraform commands work exactly as before:

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```

The configuration produces the same infrastructure as the original monolithic file but with improved organization and maintainability.
