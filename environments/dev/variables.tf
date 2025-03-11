variable "namespace" {
  description = "Namespace onde os recursos serão criados no ambiente de desenvolvimento"
  type        = string
  default     = "logging"
}

variable "elasticsearch_version" {
  description = "Versão do Elasticsearch para o ambiente de desenvolvimento"
  type        = string
  default     = "8.5.1"
}

variable "kibana_version" {
  description = "Versão do Kibana para o ambiente de desenvolvimento"
  type        = string
  default     = "8.5.1"
}

variable "fluent_bit_version" {
  description = "Versão do Fluent Bit para o ambiente de desenvolvimento"
  type        = string
  default     = "0.48.9"
}

variable "environment" {
  description = "Nome do ambiente (dev, staging, prod, etc.)"
  type        = string
  default     = "dev"
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