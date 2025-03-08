variable "namespace" {
  description = "Namespace onde o Elasticsearch será implantado"
  type        = string
}

variable "helm_version" {
  description = "Versão do Elasticsearch"
  type        = string
}

variable "resource_limits" {
  description = "Limites de recursos (replicas, CPU e memória) para os pods no ambiente de desenvolvimento"
  type = object({
    replicas = string
    cpu      = string
    memory   = string
  })
  default = {
    replicas = "1"
    cpu      = "500m"
    memory   = "512Mi"
  }
}