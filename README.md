# Amazon EKS Learning Guide with Terraform

This repository contains Terraform configuration to create a cost-effective Amazon EKS (Elastic Kubernetes Service) cluster for learning purposes.

## 🎯 What You'll Learn

### Amazon EKS Fundamentals

- **Control Plane**: AWS manages Kubernetes API server, etcd, and scheduler
- **Worker Nodes**: EC2 instances that run your containerized applications
- **Node Groups**: Collections of worker nodes with similar configurations
- **Networking**: VPC, subnets, security groups, and load balancers
- **RBAC**: Role-based access control for security

### Cost Optimization Strategies

- **Spot Instances**: Up to 90% cost savings for fault-tolerant workloads
- **Right-sizing**: Using appropriate instance types (t3.small/medium)
- **Single NAT Gateway**: Reduces networking costs
- **Managed Node Groups**: AWS handles node lifecycle management

## 💰 Cost Breakdown (Estimated Monthly)

| Component                            | Type     | Cost (USD/month) |
| ------------------------------------ | -------- | ---------------- |
| EKS Control Plane                    | Fixed    | $73              |
| Worker Nodes (2x t3.small on-demand) | Variable | ~$30             |
| Worker Nodes (1x t3.small spot)      | Variable | ~$3              |
| NAT Gateway                          | Fixed    | ~$45             |
| **Total**                            |          | **~$151/month**  |

> **Note**: Actual costs may vary based on usage, data transfer, and region.

## 🏗️ Architecture

```
┌─────────────────────────────────────────┐
│                AWS VPC                  │
│  ┌─────────────────────────────────────┐│
│  │           Public Subnets            ││
│  │  ┌─────────┐    ┌─────────────────┐ ││
│  │  │   NAT   │    │  Load Balancer  │ ││
│  │  │ Gateway │    │   (Optional)    │ ││
│  │  └─────────┘    └─────────────────┘ ││
│  └─────────────────────────────────────┘│
│  ┌─────────────────────────────────────┐│
│  │          Private Subnets            ││
│  │  ┌─────────────────────────────────┐││
│  │  │        EKS Control Plane        │││
│  │  │         (Managed by AWS)        │││
│  │  └─────────────────────────────────┘││
│  │  ┌─────────┐    ┌─────────────────┐││
│  │  │ On-Demand│    │ Spot Instance   │││
│  │  │  Nodes   │    │     Nodes       │││
│  │  │(t3.small)│    │  (t3.small)     │││
│  │  └─────────┘    └─────────────────┘││
│  └─────────────────────────────────────┘│
└─────────────────────────────────────────┘
```

## 🚀 Quick Start

### Prerequisites

- AWS CLI configured with appropriate permissions
- Terraform >= 1.0 installed
- kubectl installed
- Basic understanding of Kubernetes concepts

### Step 1: Initialize and Plan

```powershell
# Initialize Terraform
terraform init

# Review the planned changes
terraform plan
```

### Step 2: Deploy the Infrastructure

```powershell
# Apply the configuration
terraform apply
```

### Step 3: Configure kubectl

```powershell
# Get the kubectl configuration command from Terraform output
terraform output configure_kubectl

# Run the command (example):
aws eks --region ap-southeast-1 update-kubeconfig --name learning-eks-cluster
```

### Step 4: Verify the Cluster

```powershell
# Check cluster info
kubectl cluster-info

# View nodes
kubectl get nodes

# Check node labels and taints
kubectl describe nodes
```

## 🎮 Testing Your Cluster

### Deploy Sample Application

```powershell
# Deploy the sample nginx application
kubectl apply -f sample-app.yaml

# Check the deployment
kubectl get pods -n demo-app

# View services
kubectl get svc -n demo-app
```

### Monitor Resource Usage

```powershell
# Check node resource usage
kubectl top nodes

# Check pod resource usage
kubectl top pods -n demo-app

# View cluster events
kubectl get events --sort-by='.lastTimestamp'
```

## 📊 Understanding Your Infrastructure

### Node Groups Explained

1. **Main Node Group (On-Demand)**

   - **Purpose**: Stable workloads, system components
   - **Instance Type**: t3.small (2 vCPU, 2GB RAM)
   - **Scaling**: 1-3 nodes
   - **Cost**: Predictable, higher cost

2. **Spot Node Group**
   - **Purpose**: Fault-tolerant, batch workloads
   - **Instance Type**: t3.small/medium (flexible)
   - **Scaling**: 0-5 nodes
   - **Cost**: Up to 90% savings, can be interrupted

### Networking Components

- **VPC**: Isolated network environment (10.0.0.0/16)
- **Public Subnets**: For load balancers and NAT gateway
- **Private Subnets**: For EKS nodes (enhanced security)
- **NAT Gateway**: Allows outbound internet access from private subnets

## 🛡️ Security Best Practices

### IAM and RBAC

- EKS uses IAM for cluster access
- Node groups have minimal required permissions
- Service accounts can assume IAM roles (IRSA)

### Network Security

- Nodes in private subnets
- Security groups control traffic flow
- Network policies can be implemented

### Pod Security

- Resource limits prevent resource exhaustion
- Security contexts for containers
- Network policies for pod-to-pod communication

## 🔧 Common Operations

### Scaling Node Groups

```powershell
# Scale the main node group
aws eks update-nodegroup-config --cluster-name learning-eks-cluster --nodegroup-name main-nodes --scaling-config minSize=2,maxSize=4,desiredSize=3
```

### Deploying Applications with Spot Tolerance

```yaml
# Add this to your pod spec to run on spot instances
tolerations:
  - key: "spot-instance"
    operator: "Equal"
    value: "true"
    effect: "NoSchedule"
nodeSelector:
  NodeType: "spot"
```

### Installing Common Add-ons

```powershell
# AWS Load Balancer Controller
kubectl apply -f https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/v2.4.7/v2_4_7_full.yaml

# Metrics Server
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# Cluster Autoscaler
kubectl apply -f https://raw.githubusercontent.com/kubernetes/autoscaler/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-autodiscover.yaml
```

## 🧹 Cleanup

To avoid ongoing charges, destroy the infrastructure when you're done learning:

```powershell
# Destroy all resources
terraform destroy
```

> **Important**: This will delete everything! Make sure you've saved any important data.

## 📚 Next Steps

### Advanced Topics to Explore

1. **Service Mesh**: Implement Istio or AWS App Mesh
2. **GitOps**: Set up ArgoCD or Flux
3. **Monitoring**: Deploy Prometheus and Grafana
4. **Logging**: Configure Fluent Bit or Fluentd
5. **Security**: Implement Pod Security Standards
6. **CI/CD**: Integrate with GitHub Actions or AWS CodePipeline

### Cost Optimization Tips

1. Use Spot instances for development workloads
2. Implement cluster autoscaler
3. Set up proper resource requests/limits
4. Monitor costs with AWS Cost Explorer
5. Consider Fargate for small workloads

## 🆘 Troubleshooting

### Common Issues

1. **Nodes not joining cluster**

   - Check security groups
   - Verify IAM roles
   - Check subnet routing

2. **Pods stuck in Pending**

   - Check resource requests
   - Verify node capacity
   - Check taints and tolerations

3. **High costs**
   - Review instance types
   - Check for unused resources
   - Monitor data transfer costs

### Useful Commands

```powershell
# Check cluster status
kubectl get componentstatuses

# View cluster events
kubectl get events --sort-by='.lastTimestamp'

# Check node capacity
kubectl describe nodes

# View resource usage
kubectl top nodes
kubectl top pods --all-namespaces
```

## 📖 Additional Resources

- [AWS EKS User Guide](https://docs.aws.amazon.com/eks/latest/userguide/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [EKS Best Practices](https://aws.github.io/aws-eks-best-practices/)
- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

---

**Happy Learning! 🎉**

Remember: This setup is optimized for learning and development. For production workloads, additional considerations for security, monitoring, and high availability are required.
