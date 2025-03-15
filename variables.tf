variable "namespace" {
  description = "Namespace onde os recursos serão criados"
  type        = string
  default     = "logging"
}

variable "environment" {
  description = "Nome do ambiente (dev, staging, prod, etc.)"
  type        = string
  default     = "dev"
}

# Versões dos componentes
variable "elasticsearch_version" {
  description = "Versão do Elasticsearch"
  type        = string
  default     = "8.5.1"
}

variable "kibana_version" {
  description = "Versão do Kibana"
  type        = string
  default     = "8.5.1"
}

variable "fluent_bit_version" {
  description = "Versão do Fluent Bit"
  type        = string
  default     = "0.48.9"
}

# Configuração de recursos
variable "es_resource_limits" {
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

# Configuração persistência
variable "persistence_enabled" {
  description = "Habilitar persistência de dados"
  type        = bool
  default     = false
}

variable "enable_monitoring" {
  description = "Habilitar monitoramento dos componentes"
  type        = bool
  default     = false
}