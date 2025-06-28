# AWS Region
variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

# Cluster name
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "learning-eks-cluster"
}

# Environment
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "learning"
}

# Node group configuration
variable "node_group_desired_size" {
  description = "Desired number of nodes in the main node group"
  type        = number
  default     = 2
}

variable "node_group_max_size" {
  description = "Maximum number of nodes in the main node group"
  type        = number
  default     = 3
}

variable "node_group_min_size" {
  description = "Minimum number of nodes in the main node group"
  type        = number
  default     = 1
}

variable "spot_node_group_desired_size" {
  description = "Desired number of nodes in the spot node group"
  type        = number
  default     = 1
}

variable "spot_node_group_max_size" {
  description = "Maximum number of nodes in the spot node group"
  type        = number
  default     = 5
}

variable "spot_node_group_min_size" {
  description = "Minimum number of nodes in the spot node group"
  type        = number
  default     = 0
}
#networking
# iam
#security
#eks-cluster
#node-groups