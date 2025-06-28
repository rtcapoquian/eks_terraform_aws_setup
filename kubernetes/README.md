# Kubernetes Application Manifests

This directory contains all Kubernetes YAML manifests for deploying multiple diverse applications on the EKS cluster.

## 📁 Files Overview

### Core Database
- **`mongo-secret.yaml`** - MongoDB credentials (base64 encoded)
- **`mongo-config.yaml`** - MongoDB connection configuration
- **`mongo.yaml`** - MongoDB deployment and service

### Web Applications
- **`webapp.yaml`** - Main web application (Node.js)
- **`frontend-app.yaml`** - Frontend application (Nginx)
- **`api-service.yaml`** - REST API service (Apache)
- **`dashboard-app.yaml`** - Admin dashboard (BusyBox)
- **`loadtest-app.yaml`** - Load testing application (Nginx)

### Gateway & Routing
- **`nginx-gateway.yaml`** - Nginx reverse proxy for routing all applications
- **`aws-lb-controller.yaml`** - AWS Load Balancer Controller (alternative)
- **`multi-app-ingress.yaml`** - ALB Ingress configuration (alternative)

## 🚀 Deployment Order

1. **Secrets & Config** (first)
   ```bash
   kubectl apply -f mongo-secret.yaml
   kubectl apply -f mongo-config.yaml
   ```

2. **Database**
   ```bash
   kubectl apply -f mongo.yaml
   ```

3. **Applications**
   ```bash
   kubectl apply -f webapp.yaml
   kubectl apply -f frontend-app.yaml
   kubectl apply -f api-service.yaml
   kubectl apply -f dashboard-app.yaml
   kubectl apply -f loadtest-app.yaml
   ```

4. **Gateway** (for external access)
   ```bash
   kubectl apply -f nginx-gateway.yaml
   ```

## 🌐 Service Architecture

### Current Setup (Nginx Gateway)
```
External Users → AWS ELB → nginx-gateway-service → nginx-gateway pod → Internal Services
```

All internal services use `ClusterIP` type and are routed through the nginx gateway.

### Alternative Setup (ALB Ingress)
```
External Users → AWS ALB → Direct to Services (via Ingress rules)
```

To use this approach:
1. Deploy AWS Load Balancer Controller
2. Apply the multi-app-ingress.yaml

## 🔧 Service Types

| Service | Type | Purpose |
|---------|------|---------|
| `mongo-service` | ClusterIP | Internal database access |
| `webapp-service` | ClusterIP | Internal web app access |
| `frontend-service` | ClusterIP | Internal frontend access |
| `api-service` | ClusterIP | Internal API access |
| `dashboard-service` | ClusterIP | Internal dashboard access |
| `loadtest-service` | ClusterIP | Internal load test access |
| `nginx-gateway-service` | LoadBalancer | **External entry point** |

## 📊 Resource Allocation

### Memory & CPU Limits
```yaml
webapp:     128Mi / 100m CPU
frontend:   128Mi / 100m CPU  
api:        256Mi / 200m CPU
dashboard:  64Mi  / 50m CPU
loadtest:   128Mi / 100m CPU
nginx:      128Mi / 100m CPU
mongo:      No limits (default)
```

### Replica Configuration
All applications start with 1 replica for resource efficiency.

## 🎯 Application Routes

Access all apps through the nginx gateway:

| Route | Application | Internal Service |
|-------|-------------|------------------|
| `/` | Main Web App | `webapp-service:3000` |
| `/frontend/` | Frontend | `frontend-service:80` |
| `/api/` | API Service | `api-service:8080` |
| `/dashboard/` | Dashboard | `dashboard-service:8080` |
| `/loadtest/` | Load Test | `loadtest-service:80` |
| `/health` | Health Check | Built-in nginx |

## 🔍 Troubleshooting

### Check Pod Status
```bash
kubectl get pods -o wide
kubectl describe pod POD_NAME
```

### Check Services
```bash
kubectl get services
kubectl describe service SERVICE_NAME
```

### Check Logs
```bash
kubectl logs deployment/webapp-deployment
kubectl logs deployment/nginx-gateway
```

### Test Internal Connectivity
```bash
kubectl exec -it nginx-gateway-POD -- curl webapp-service:3000
kubectl exec -it nginx-gateway-POD -- curl api-service:8080
```

### Check ConfigMap
```bash
kubectl describe configmap nginx-config
```

## 🔒 Security Notes

- Secrets are base64 encoded (not encrypted)
- All pods run with default security context
- Services use ClusterIP for internal communication
- Only nginx gateway has external exposure

## 📈 Scaling Examples

```bash
# Scale individual applications
kubectl scale deployment webapp-deployment --replicas=3
kubectl scale deployment frontend-deployment --replicas=2
kubectl scale deployment api-deployment --replicas=3

# Check distribution
kubectl get pods -o wide
```

## 🧹 Cleanup

```bash
# Delete all applications
kubectl delete -f .

# Or delete individually
kubectl delete -f nginx-gateway.yaml
kubectl delete -f webapp.yaml
kubectl delete -f frontend-app.yaml
kubectl delete -f api-service.yaml
kubectl delete -f dashboard-app.yaml
kubectl delete -f loadtest-app.yaml
kubectl delete -f mongo.yaml
kubectl delete -f mongo-config.yaml
kubectl delete -f mongo-secret.yaml
```

## 📝 Notes

- All applications include tolerations for spot instances
- Resource limits help with pod scheduling
- ConfigMaps and Secrets should be applied first
- Nginx gateway provides single point of external access
- Applications are designed for learning, not production use
