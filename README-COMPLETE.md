# Cost-Effective EKS Learning Cluster

A complete, production-ready Amazon EKS cluster setup using Terraform with multiple diverse web applications for learning Kubernetes concepts.

## 🎯 Project Overview

This project demonstrates:
- **Cost-effective EKS cluster** with spot instances
- **Multiple web applications** with single ALB routing
- **Infrastructure as Code** using Terraform
- **Kubernetes best practices** for deployments and services
- **Real-world scenarios** for scaling and troubleshooting

## 🏗️ Architecture

```
Internet → AWS Load Balancer → Nginx Gateway → Multiple Applications
                                    ↓
                      ┌─────────────────────────────┐
                      │     EKS Cluster (5 nodes)  │
                      │  - 2 On-Demand (main)      │
                      │  - 3 Spot instances         │
                      └─────────────────────────────┘
                                    ↓
              ┌─────────────────────────────────────────────┐
              │              Applications                   │
              │  • MongoDB                                  │
              │  • Main Web App                            │
              │  • Frontend App                            │
              │  • API Service                             │
              │  • Dashboard                               │
              │  • Load Testing App                        │
              │  • Nginx Gateway (reverse proxy)          │
              └─────────────────────────────────────────────┘
```

## 💰 Cost Optimization

- **Spot instances** for 60% cost savings
- **t2.micro** instances (free tier eligible)
- **Single ALB** instead of multiple load balancers
- **Right-sized resources** with proper limits

**Estimated monthly cost: ~$50-70/month**

## 🚀 Quick Start

### Prerequisites
- AWS CLI configured
- Terraform >= 1.0
- kubectl installed

### 1. Deploy Infrastructure
```bash
cd terraform-eks-cluster
terraform init
terraform plan
terraform apply
```

### 2. Configure kubectl
```bash
aws eks update-kubeconfig --region ap-southeast-1 --name my-learning-eks-cluster
```

### 3. Deploy Applications
```bash
cd kubernetes
kubectl apply -f mongo-secret.yaml
kubectl apply -f mongo-config.yaml
kubectl apply -f mongo.yaml
kubectl apply -f webapp.yaml
kubectl apply -f frontend-app.yaml
kubectl apply -f api-service.yaml
kubectl apply -f dashboard-app.yaml
kubectl apply -f loadtest-app.yaml
kubectl apply -f nginx-gateway.yaml
```

### 4. Access Applications
```bash
kubectl get services nginx-gateway-service
# Use the external LoadBalancer URL
```

## 📁 Project Structure

```
├── terraform/
│   ├── main.tf                 # Main Terraform configuration
│   ├── providers.tf            # AWS provider configuration
│   ├── variables.tf            # Input variables
│   ├── terraform.tfvars        # Variable values
│   ├── data.tf                 # Data sources
│   ├── networking.tf           # VPC, subnets, NAT gateway
│   ├── eks-cluster.tf          # EKS cluster and IAM
│   └── node-groups.tf          # EKS node groups
│
├── kubernetes/
│   ├── mongo-secret.yaml       # MongoDB credentials
│   ├── mongo-config.yaml       # MongoDB configuration
│   ├── mongo.yaml              # MongoDB deployment
│   ├── webapp.yaml             # Main web application
│   ├── frontend-app.yaml       # Frontend application
│   ├── api-service.yaml        # API service
│   ├── dashboard-app.yaml      # Admin dashboard
│   ├── loadtest-app.yaml       # Load testing app
│   ├── nginx-gateway.yaml      # Nginx reverse proxy
│   ├── aws-lb-controller.yaml  # AWS Load Balancer Controller
│   └── multi-app-ingress.yaml  # Alternative ALB Ingress
│
└── docs/
    ├── README.md
    ├── DEPLOYMENT.md
    └── FILE_ORGANIZATION.md
```

## 🌐 Application Routes

All applications are accessible through a single LoadBalancer URL:

| Application | Route | Description |
|-------------|-------|-------------|
| Main App | `/` | Primary web application |
| Frontend | `/frontend/` | Frontend application |
| API | `/api/` | REST API service |
| Dashboard | `/dashboard/` | Admin dashboard |
| Load Test | `/loadtest/` | Load testing tools |
| Health | `/health` | Health check endpoint |

## 🎓 Learning Concepts Covered

### Terraform
- ✅ Infrastructure as Code
- ✅ Resource organization
- ✅ Variables and outputs
- ✅ Cost optimization strategies

### Kubernetes
- ✅ Deployments and ReplicaSets
- ✅ Services (ClusterIP, NodePort, LoadBalancer)
- ✅ ConfigMaps and Secrets
- ✅ Resource limits and requests
- ✅ Node selectors and tolerations
- ✅ Pod scheduling and anti-affinity

### AWS EKS
- ✅ Cluster setup and configuration
- ✅ Node groups (spot vs on-demand)
- ✅ IAM roles and policies
- ✅ VPC and networking
- ✅ Load balancer integration

### DevOps
- ✅ Multi-application deployment
- ✅ Service discovery
- ✅ Reverse proxy configuration
- ✅ Scaling strategies
- ✅ Troubleshooting techniques

## 🔧 Common Operations

### Scale Applications
```bash
kubectl scale deployment webapp-deployment --replicas=3
kubectl scale deployment frontend-deployment --replicas=2
```

### Add More Nodes
```bash
# Edit terraform.tfvars
node_group_desired_size = 3
spot_node_group_desired_size = 3

# Apply changes
terraform apply
```

### Monitor Resources
```bash
kubectl top nodes
kubectl top pods
kubectl get pods -o wide
```

### Check Logs
```bash
kubectl logs -f deployment/webapp-deployment
kubectl logs -f deployment/nginx-gateway
```

## 🚨 Troubleshooting

### Pods Pending
- Check node capacity: `kubectl describe nodes`
- Verify tolerations for spot instances
- Check resource requests vs available capacity

### Cannot Access Applications
- Verify LoadBalancer: `kubectl get services`
- Check nginx configuration: `kubectl describe configmap nginx-config`
- Test internal connectivity: `kubectl exec -it POD_NAME -- curl SERVICE_NAME`

### High Costs
- Monitor spot instance usage
- Check if nodes are properly sized
- Verify auto-scaling is working

## 🧹 Cleanup

```bash
# Delete Kubernetes resources
kubectl delete -f kubernetes/

# Destroy infrastructure
terraform destroy
```

## 📚 Next Steps

1. **Add monitoring** with Prometheus and Grafana
2. **Implement logging** with ELK stack
3. **Set up CI/CD** with GitHub Actions
4. **Add SSL/TLS** certificates
5. **Implement auto-scaling** with Cluster Autoscaler
6. **Add security scanning** and policies

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## ⚠️ Important Notes

- This is a **learning environment** - not for production use
- Monitor costs regularly
- Keep security credentials secure
- Update Terraform and Kubernetes regularly

---

**Happy Learning! 🎉**

Built with ❤️ for the Kubernetes community.
