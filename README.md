# Logging Aggregator with Terraform

This project automates the deployment of a centralized logging stack on __Kubernetes__ using __Terraform__. The stack includes __Elasticsearch__, __Kibana__, and __Fluent Bit__ for log storage, visualization, and collection.

## Features
- __Infrastructure as Code__: Deploy and manage resources using Terraform.

- __Modular Design__: Reusable modules for Elasticsearch, Kibana, and Fluent Bit.

- __Multi-Environment Support__: Separate configurations for dev, staging, and prod.

- __Resource Limits__: Configurable CPU and memory limits.

## Prerequisites
- __Terraform__: [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

- __Kubectl__: [Install kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

- __Helm__: [Install Helm](https://helm.sh/docs/intro/install/)

- __Minikube__ (optional, for local testing): [Install Minikube](https://minikube.sigs.k8s.io/docs/start/)

## Getting Started
1. Clone the repository:
```bash
git clone https://github.com/FelipeSSac/logging-aggregator.git

cd logging-aggregator
```

2. Initialize Terraform:
```bash
terraform init
```

3. Deploy the infrastructure:
```bash
terraform apply
```

## Project Structure
```
logging-aggregator/
├── main.tf                  # Root module configuration
├── variables.tf             # Root module variables
├── modules/                 # Reusable Terraform modules
│   ├── elasticsearch/       # Elasticsearch module
│   ├── kibana/              # Kibana module
│   └── fluent-bit/          # Fluent Bit module
└── environments/            # Environment-specific configurations
```

## Customization
Modify `variables.tf` or `terraform.tfvars` to customize:

- __Namespace__: Kubernetes namespace for the stack.

- __Versions__: Elasticsearch, Kibana, and Fluent Bit versions.

- __Resource Limits__: CPU and memory limits.

Example `terraform.tfvars`:

```hcl
namespace             = "logging"
elasticsearch_version = "8.10.0"
kibana_version        = "8.10.0"
fluent_bit_version    = "2.1.10"
```

## Troubleshooting

- Helm Release Fails:
```bash
helm status elasticsearch -n <namespace>

kubectl logs <pod-name> -n <namespace>
```

- PersistentVolume Issues:
```bash
kubectl get pvc -n <namespace>
```

## License
This project is licensed under the __MIT LICENSE__. See [License](https://license/) for details.