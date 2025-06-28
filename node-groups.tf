# EKS Node Groups Configuration
# Contains IAM roles for node groups, on-demand and spot node group configurations

# Node Group IAM Role
resource "aws_iam_role" "node_group" {
  name = "${var.cluster_name}-node-group-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.cluster_name}-node-group-role"
    Environment = var.environment
    Terraform   = "true"
  }
}

# Node Group Policy Attachments
resource "aws_iam_role_policy_attachment" "node_group_worker_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_group.name
}

resource "aws_iam_role_policy_attachment" "node_group_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_group.name
}

resource "aws_iam_role_policy_attachment" "node_group_registry_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_group.name
}

# On-Demand Node Group
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "main-nodes"
  node_role_arn   = aws_iam_role.node_group.arn
  subnet_ids      = aws_subnet.private[*].id

  capacity_type  = "ON_DEMAND"
  instance_types = ["t2.micro"]
  ami_type       = "AL2_x86_64"
  disk_size      = 20

  scaling_config {
    desired_size = var.node_group_desired_size
    max_size     = var.node_group_max_size
    min_size     = var.node_group_min_size
  }

  labels = {
    Environment = var.environment
    NodeType    = "main"
  }

  # Ensure proper ordering of resource creation
  depends_on = [
    aws_iam_role_policy_attachment.node_group_worker_policy,
    aws_iam_role_policy_attachment.node_group_cni_policy,
    aws_iam_role_policy_attachment.node_group_registry_policy,
  ]

  tags = {
    Name        = "main-nodes"
    Environment = var.environment
    Terraform   = "true"
  }
}

# Spot Node Group
resource "aws_eks_node_group" "spot" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "spot-nodes"
  node_role_arn   = aws_iam_role.node_group.arn
  subnet_ids      = aws_subnet.private[*].id

  capacity_type  = "SPOT"
  instance_types = ["t2.micro", "t3.medium"]
  ami_type       = "AL2_x86_64"
  disk_size      = 20

  scaling_config {
    desired_size = var.spot_node_group_desired_size
    max_size     = var.spot_node_group_max_size
    min_size     = var.spot_node_group_min_size
  }

  labels = {
    Environment  = var.environment
    NodeType     = "spot"
    SpotInstance = "true"
  }

  taint {
    key    = "spot-instance"
    value  = "true"
    effect = "NO_SCHEDULE"
  }

  # Ensure proper ordering of resource creation
  depends_on = [
    aws_iam_role_policy_attachment.node_group_worker_policy,
    aws_iam_role_policy_attachment.node_group_cni_policy,
    aws_iam_role_policy_attachment.node_group_registry_policy,
  ]

  tags = {
    Name        = "spot-nodes"
    Environment = var.environment
    Terraform   = "true"
    NodeType    = "spot"
  }
}
