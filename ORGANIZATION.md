# Terraform Code Organization Guide

## 📁 Project Structure

The EKS infrastructure has been organized into multiple files for better maintainability and clarity:

```
eks/
├── main.tf                      # Entry point and documentation
├── providers.tf                 # Provider configurations
├── variables.tf                 # Input variables
├── locals.tf                    # Local values and computed variables
├── data.tf                      # Data sources
├── vpc.tf                       # VPC and networking resources
├── eks.tf                       # EKS cluster and node groups
├── iam.tf                       # IAM roles and policies
├── security.tf                  # Security group rules
├── outputs.tf                   # Output values
├── terraform.tfvars.example     # Example variable values
├── sample-app.yaml              # Kubernetes sample application
├── README.md                    # Complete documentation
├── DEPLOYMENT.md                # Deployment instructions
└── ORGANIZATION.md              # This file
```

## 📋 File Descriptions

### Core Configuration Files

#### **main.tf**

- **Purpose**: Entry point and documentation
- **Contains**: Comments explaining the project structure
- **Note**: Minimal content - actual resources are in dedicated files

#### **providers.tf**

- **Purpose**: Provider and Terraform version constraints
- **Contains**: AWS provider configuration and version requirements

#### **variables.tf**

- **Purpose**: Input variable definitions
- **Contains**: All configurable parameters with descriptions and defaults

#### **locals.tf**

- **Purpose**: Computed values and common configurations
- **Contains**:
  - Cluster name resolution
  - Common tags for all resources
  - VPC-specific tags for EKS integration

### Resource-Specific Files

#### **data.tf**

- **Purpose**: External data lookups
- **Contains**:
  - Availability zones data source
  - EKS cluster authentication data

#### **vpc.tf**

- **Purpose**: Networking infrastructure
- **Contains**:
  - VPC module configuration
  - Subnet definitions (public/private)
  - NAT Gateway setup
  - EKS-specific subnet tags

#### **eks.tf**

- **Purpose**: Kubernetes cluster configuration
- **Contains**:
  - EKS cluster module
  - Managed node groups (on-demand and spot)
  - Cluster access configuration

#### **iam.tf**

- **Purpose**: Identity and access management
- **Contains**:
  - Load Balancer Controller IAM role
  - Service account role mappings

#### **security.tf**

- **Purpose**: Security group configurations
- **Contains**:
  - Additional security group rules
  - Cluster access rules

#### **outputs.tf**

- **Purpose**: Export important values
- **Contains**:
  - Cluster information
  - Network details
  - Configuration commands

## 🔄 Benefits of This Organization

### **Maintainability**

- **Separation of Concerns**: Each file handles a specific aspect
- **Easier Navigation**: Find specific resources quickly
- **Reduced Conflicts**: Multiple developers can work on different areas

### **Readability**

- **Clear Structure**: Logical grouping of related resources
- **Focused Files**: Each file has a single responsibility
- **Better Documentation**: Inline comments for each section

### **Scalability**

- **Modular Design**: Easy to add new components
- **Environment Specific**: Variables allow easy customization
- **Version Control**: Smaller files = better diff tracking

## 🔧 Working with the New Structure

### **Making Changes**

1. **VPC Changes**: Edit `vpc.tf`
2. **Cluster Configuration**: Edit `eks.tf`
3. **IAM Permissions**: Edit `iam.tf`
4. **Security Rules**: Edit `security.tf`
5. **Variables**: Edit `variables.tf`

### **Adding New Features**

1. **Create appropriate file** (e.g., `monitoring.tf`)
2. **Add variables** to `variables.tf` if needed
3. **Update outputs** in `outputs.tf` if needed
4. **Update locals** in `locals.tf` for common values

### **Best Practices**

#### **File Naming**

- Use descriptive, lowercase names
- Group related resources in the same file
- Use `.tf` extension for all Terraform files

#### **Comments**

- Add file headers explaining purpose
- Comment complex configurations
- Explain non-obvious decisions

#### **Variables**

- Define all variables in `variables.tf`
- Use meaningful names and descriptions
- Provide sensible defaults

#### **Tags**

- Use common tags from `locals.tf`
- Add resource-specific tags as needed
- Follow consistent tagging strategy

## 🔍 Understanding Dependencies

### **File Dependencies**

```
providers.tf
    ↓
variables.tf → locals.tf
    ↓              ↓
data.tf ←→ vpc.tf → eks.tf → iam.tf
    ↓              ↓    ↓      ↓
security.tf ←──────┴────┴──────┘
    ↓
outputs.tf
```

### **Resource Dependencies**

- **VPC** must exist before EKS cluster
- **EKS cluster** must exist before node groups
- **OIDC provider** must exist before IAM roles
- **Security groups** created with cluster

## 🛠️ Migration Notes

### **State Compatibility**

- All resources maintain the same Terraform addresses
- No state migration required
- Existing deployments continue to work

### **Functionality Preserved**

- All original functionality maintained
- Same resource configurations
- Identical deployment outcomes

### **Enhanced Features**

- Better organization
- Improved maintainability
- Enhanced documentation
- Easier customization

## 📚 Common Operations

### **Viewing Configuration**

```powershell
# View specific component
Get-Content vpc.tf
Get-Content eks.tf

# View all variables
Get-Content variables.tf

# View outputs
Get-Content outputs.tf
```

### **Planning Changes**

```powershell
# Plan infrastructure changes
terraform plan

# Plan with custom variables
terraform plan -var-file="custom.tfvars"

# Plan specific targets
terraform plan -target=module.vpc
```

### **Applying Changes**

```powershell
# Apply all changes
terraform apply

# Apply specific component
terraform apply -target=module.eks

# Apply with auto-approve
terraform apply -auto-approve
```

## 🔄 Version Control Best Practices

### **Commit Strategy**

- Commit related changes together
- Use descriptive commit messages
- Reference file changes in commits

### **Branch Strategy**

- Feature branches for new components
- Separate branches for different environments
- Test changes before merging

### **Review Process**

- Review changes by file type
- Focus on security implications
- Validate variable changes

This organization makes the EKS infrastructure more professional, maintainable, and easier to work with while preserving all functionality and state compatibility.
