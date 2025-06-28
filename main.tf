# EKS Infrastructure - Complete Configuration
# All resources defined directly without external modules
#
# This is a refactored version where the main.tf file has been split
# into logical components for better organization and readability:
#
# - networking.tf: Data sources, VPC, subnets, gateways, route tables
# - eks-cluster.tf: IAM roles for cluster, security groups, EKS cluster
# - node-groups.tf: IAM roles for nodes, on-demand and spot node groups
#
# All resources are still native AWS resources without modules.
