# outputs.tf
# Output values for the EKS cluster and related resources

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

output "cluster_iam_role_name" {
  description = "IAM role name associated with EKS cluster"
  value       = aws_iam_role.cluster.name
}

output "cluster_iam_role_arn" {
  description = "IAM role ARN associated with EKS cluster"
  value       = aws_iam_role.cluster.arn
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.main.name
}

output "cluster_version" {
  description = "Version of the EKS cluster"
  value       = aws_eks_cluster.main.version
}

output "node_groups" {
  description = "EKS node groups"
  value = {
    main = aws_eks_node_group.main.arn
    spot = aws_eks_node_group.spot.arn
  }
}

output "vpc_id" {
  description = "ID of the VPC where the cluster and workers are deployed"
  value       = aws_vpc.main.id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private[*].id
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "nat_gateway_ip" {
  description = "IP address of the NAT Gateway"
  value       = aws_eip.nat.public_ip
}

output "kubectl_config_command" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${aws_eks_cluster.main.name}"
}

output "cost_estimate" {
  description = "Estimated monthly cost breakdown"
  value = {
    "NAT Gateway"     = "~$32/month"
    "EKS Cluster"     = "~$72/month" 
    "On-Demand Nodes" = "~$17/month (2 x t2.micro)"
    "Spot Nodes"      = "~$7/month (3 x t2.micro @ 60% discount)"
    "Load Balancer"   = "~$18/month"
    "Total Estimate"  = "~$146/month"
    "Note"           = "Actual costs may vary based on usage and AWS pricing changes"
  }
}
