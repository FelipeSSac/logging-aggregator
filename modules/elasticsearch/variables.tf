variable "namespace" {
  description = "Namespace onde o Elasticsearch será implantado"
  type        = string
}

variable "helm_version" {
  description = "Versão do Elasticsearch"
  type        = string
}

variable "resource_limits" {
  description = "Limites de recursos para os pods do Elasticsearch"
  type = object({
    replicas = string
    cpu      = string
    memory   = string
  })
  default = {
    replicas = "1"
    cpu      = "2000m"
    memory   = "4Gi"
  }
}

variable "persistence_enabled" {
  description = "Habilitar persistência de dados"
  type        = bool
  default     = false
}

variable "enable_monitoring" {
  description = "Habilitar monitoramento"
  type        = bool
  default     = false
}

variable "tls_enabled" {
  description = "Habilitar TLS"
  type        = bool
  default     = false
}

variable "environment" {
  description = "Ambiente onde o Elasticsearch será implantado"
  type        = string
  default     = "dev"
}
