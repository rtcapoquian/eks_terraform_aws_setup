# EKS Deployment Guide - Step by Step

## 🚀 Deployment Steps

### Step 1: Pre-deployment Checklist

```powershell
# Check AWS CLI configuration
aws sts get-caller-identity

# Verify you have the necessary permissions:
# - EKS full access
# - VPC full access
# - IAM permissions to create roles
# - EC2 full access

# Check current AWS region
aws configure get region
```

### Step 2: Deploy the EKS Cluster

```powershell
# Deploy infrastructure (takes 10-15 minutes)
terraform apply

# Type 'yes' when prompted
```

### Step 3: Configure kubectl

```powershell
# Update kubeconfig (run the command from terraform output)
aws eks --region ap-southeast-1 update-kubeconfig --name learning-eks-cluster

# Verify connection
kubectl get nodes
```

### Step 4: Deploy Sample Application

```powershell
# Deploy the sample app
kubectl apply -f sample-app.yaml

# Check deployment status
kubectl get pods -n demo-app
kubectl get svc -n demo-app
```

## 💰 Cost Management Tips

### Current Configuration Costs (Monthly Estimates)

- **EKS Control Plane**: $73.00 (fixed)
- **2x t3.small On-Demand**: ~$30.00
- **1x t3.small Spot**: ~$3.00
- **NAT Gateway**: ~$45.00
- **Data Transfer**: ~$5-10.00
- **Storage (EBS)**: ~$2.00
- **Total**: ~$155-160/month

### Cost Optimization Strategies

#### 1. Scale Down for Learning

```powershell
# Scale down to minimum for cost savings
kubectl scale deployment nginx-deployment --replicas=1 -n demo-app

# Scale node groups to minimum
aws eks update-nodegroup-config \
  --cluster-name learning-eks-cluster \
  --nodegroup-name main-nodes \
  --scaling-config minSize=1,maxSize=2,desiredSize=1
```

#### 2. Stop Cluster When Not Using

```powershell
# Scale all node groups to 0 (stops EC2 charges)
aws eks update-nodegroup-config \
  --cluster-name learning-eks-cluster \
  --nodegroup-name main-nodes \
  --scaling-config minSize=0,maxSize=3,desiredSize=0

aws eks update-nodegroup-config \
  --cluster-name learning-eks-cluster \
  --nodegroup-name spot-nodes \
  --scaling-config minSize=0,maxSize=5,desiredSize=0

# Note: Control plane still charges $73/month
```

#### 3. Use Spot Instances for Development

```yaml
# Add to your pod specs to prefer spot instances
nodeSelector:
  NodeType: "spot"
tolerations:
  - key: "spot-instance"
    operator: "Equal"
    value: "true"
    effect: "NoSchedule"
```

#### 4. Set Resource Limits

```yaml
# Always set resource limits to prevent runaway costs
resources:
  requests:
    memory: "64Mi"
    cpu: "50m"
  limits:
    memory: "128Mi"
    cpu: "100m"
```

## 🔧 Common Commands

### Cluster Management

```powershell
# View cluster info
kubectl cluster-info

# Check cluster events
kubectl get events --sort-by='.lastTimestamp'

# View all resources
kubectl get all --all-namespaces
```

### Node Management

```powershell
# List nodes with labels
kubectl get nodes --show-labels

# Check node capacity
kubectl describe nodes

# View node resource usage
kubectl top nodes
```

### Application Management

```powershell
# View pods across all namespaces
kubectl get pods --all-namespaces

# Check pod logs
kubectl logs -n demo-app deployment/nginx-deployment

# Port forward to access application locally
kubectl port-forward -n demo-app svc/nginx-service 8080:80
```

### Troubleshooting

```powershell
# Check pod status and events
kubectl describe pod <pod-name> -n demo-app

# View kubelet logs on nodes
kubectl logs -n kube-system daemonset/aws-node

# Check cluster autoscaler logs
kubectl logs -n kube-system deployment/cluster-autoscaler
```

## ⚠️ Important Reminders

### Cost Alerts

1. **Set up AWS billing alerts** for $50, $100, $150
2. **Monitor usage** daily during learning
3. **Scale down** when not actively using
4. **Destroy resources** when done learning

### Security Notes

1. **Current setup allows public access** - fine for learning
2. **Production clusters** should restrict access
3. **Never commit AWS credentials** to version control
4. **Use IAM roles** instead of access keys when possible

### Best Practices

1. **Always set resource limits** on pods
2. **Use namespaces** to organize resources
3. **Tag all resources** for cost tracking
4. **Monitor cluster metrics** regularly
5. **Keep Kubernetes version updated**

## 🧹 Cleanup When Done

### Option 1: Scale to Zero (Keep Infrastructure)

```powershell
# Stop all workloads but keep cluster
kubectl delete namespace demo-app

# Scale node groups to 0
aws eks update-nodegroup-config \
  --cluster-name learning-eks-cluster \
  --nodegroup-name main-nodes \
  --scaling-config minSize=0,maxSize=3,desiredSize=0
```

### Option 2: Complete Cleanup

```powershell
# Destroy everything
terraform destroy

# Type 'yes' when prompted
# This will take 10-15 minutes
```

## 📚 Next Learning Steps

### Week 1: Basics

- [ ] Deploy simple applications
- [ ] Understand pods, services, deployments
- [ ] Practice kubectl commands
- [ ] Learn about resource limits

### Week 2: Networking

- [ ] Services and ingress
- [ ] Load balancers
- [ ] Network policies
- [ ] DNS in Kubernetes

### Week 3: Storage

- [ ] Persistent volumes
- [ ] Storage classes
- [ ] EBS CSI driver
- [ ] StatefulSets

### Week 4: Advanced Topics

- [ ] Helm package manager
- [ ] Monitoring with Prometheus
- [ ] Logging with Fluent Bit
- [ ] CI/CD with GitOps

## 🆘 Getting Help

### Official Documentation

- [AWS EKS User Guide](https://docs.aws.amazon.com/eks/latest/userguide/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

### Community Resources

- [EKS Workshops](https://www.eksworkshop.com/)
- [Kubernetes Slack](https://kubernetes.slack.com/)
- [AWS re:Post](https://repost.aws/)

### Troubleshooting

- Check AWS CloudTrail for API calls
- Review EKS cluster logs in CloudWatch
- Use `kubectl describe` for detailed resource info
- Check node group autoscaling events

Remember: This is a learning environment optimized for cost-effectiveness. Production deployments require additional security, monitoring, and high-availability considerations.
