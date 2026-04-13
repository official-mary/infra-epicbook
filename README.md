# Infra-EpicBook

Infrastructure as Code for deploying the Epic Book application on Azure using Terraform.

## Overview

This project provisions the necessary Azure infrastructure for the Epic Book application, including:

- **Virtual Network**: Isolated network with public and private subnets
- **Virtual Machine**: Ubuntu-based VM for hosting the application
- **MySQL Database**: Azure MySQL Flexible Server with private networking
- **Security**: Network Security Groups and private DNS zones

## Architecture

```
┌─────────────────┐    ┌─────────────────┐
│   Public Subnet │    │  Private Subnet │
│                 │    │                 │
│  ┌────────────┐ │    │  ┌────────────┐ │
│  │   Ubuntu   │ │    │  │   MySQL    │ │
│  │     VM     │◄┼────┼─►│   Server   │ │
│  │            │ │    │  │            │ │
│  └────────────┘ │    │  └────────────┘ │
└─────────────────┘    └─────────────────┘
         │
         ▼
   ┌────────────┐
   │   Public   │
   │     IP     │
   └────────────┘
```

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.5.0
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) or Azure account with appropriate permissions
- SSH key pair for VM access (expected at `~/.ssh/epicbook_key.pub`)

## Quick Start

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd infra-epicbook
   ```

2. **Initialize Terraform**
   ```bash
   terraform init
   ```

3. **Configure variables** (optional)
   Edit `terraform.tfvars` or set environment variables:
   ```bash
   export TF_VAR_db_password="your-secure-password"
   ```

4. **Plan the deployment**
   ```bash
   terraform plan
   ```

5. **Apply the infrastructure**
   ```bash
   terraform apply
   ```

6. **Get outputs**
   ```bash
   terraform output
   ```

## Configuration

### Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `resource_prefix` | Prefix for all Azure resources | `epicbook-prod` |
| `location` | Azure region | `South Africa North` |
| `vm_size` | Azure VM instance type | `Standard_B2ats_v2` |
| `admin_username` | VM administrator username | `ubuntu` |
| `db_name` | MySQL database name | `bookstore` |
| `db_user` | MySQL administrator username | `epicbook_user` |
| `db_password` | MySQL administrator password | *(required)* |

### Outputs

| Output | Description |
|--------|-------------|
| `public_ip` | Public IP address of the VM |
| `admin_user` | VM administrator username |
| `db_host` | MySQL server fully qualified domain name |

## CI/CD Pipeline

This project includes a comprehensive Azure DevOps pipeline (`azure-pipelines.yml`) that automates the provisioning of the Epic Book infrastructure. The pipeline follows Infrastructure as Code best practices with separate stages for initialization, planning, and application.

### Pipeline Overview

The pipeline is triggered on commits to the `main` branch and consists of three sequential stages:

#### 1. Terraform Init Stage
- **Purpose**: Initializes the Terraform working directory
- **Actions**:
  - Checks out the infrastructure repository
  - Verifies Terraform version compatibility
  - Runs `terraform init` to download providers and modules

#### 2. Terraform Plan Stage
- **Purpose**: Creates and validates an execution plan
- **Actions**:
  - Re-initializes Terraform (for safety)
  - Generates a Terraform plan with `terraform plan -out=tfplan`
  - Publishes the plan as a pipeline artifact for review
- **Benefits**: Allows manual review of changes before applying them

#### 3. Terraform Apply Stage
- **Purpose**: Applies the infrastructure changes to Azure
- **Actions**:
  - Downloads the approved plan artifact
  - Re-initializes Terraform
  - Applies changes with `terraform apply -auto-approve`
  - Extracts and displays key outputs (public IP, database host)
  - Sets pipeline variables for downstream consumption

### Pipeline Configuration

- **Agent Pool**: Uses a self-hosted agent pool (`SelfHostedPool`)
- **Trigger**: Automatic on `main` branch pushes
- **Artifact Management**: Plan artifacts are stored and retrieved between stages
- **Output Variables**: Pipeline variables are set for integration with other pipelines

### Benefits of Pipeline-Based Infrastructure Provisioning

- **Consistency**: Ensures identical deployments across environments
- **Auditability**: All changes are tracked through version control
- **Review Process**: Plan stage allows for change review before execution
- **Automation**: Reduces manual errors and speeds up deployments
- **Integration**: Outputs can be consumed by application deployment pipelines

### Manual vs Pipeline Deployment

While the Quick Start section shows manual Terraform commands, the recommended approach for production deployments is through the CI/CD pipeline to ensure:

- Change tracking and approval workflows
- Consistent execution environment
- Integration with broader DevOps processes
- Automated rollback capabilities

## Security Considerations

- VM uses SSH key authentication (password authentication disabled)
- MySQL server is deployed in a private subnet with delegated networking
- Network Security Group allows SSH (22) and HTTP (80) traffic
- Database credentials should be stored securely (consider Azure Key Vault)

## Connecting to Resources

### SSH to VM
```bash
ssh -i ~/.ssh/epicbook_key ubuntu@<public_ip>
```

### Connect to Database
```bash
mysql -h <db_host> -u <db_user> -p
```

## Cleanup

To destroy all resources:
```bash
terraform destroy
```

## Contributing

1. Create a feature branch
2. Make your changes
3. Test with `terraform plan` and `terraform apply`
4. Submit a pull request

## License

MIT License

Copyright (c) 2026 OGBONNA NWANNEKA MARY

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.</content>
<parameter name="filePath">/home/mary/infra-epicbook/README.md