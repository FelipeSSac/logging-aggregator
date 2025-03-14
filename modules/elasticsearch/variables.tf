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
    cpu      = "1000m"
    memory   = "1Gi"
  }
}

variable "enable_requests" {
  description = "Habilitar requests de recursos"
  type        = bool
  default     = true
}

variable "persistence_enabled" {
  description = "Habilitar persistência de dados"
  type        = bool
  default     = false
}

variable "storage_size" {
  description = "Tamanho do volume de armazenamento"
  type        = string
  default     = "10Gi"
}

variable "enable_snapshots" {
  description = "Habilitar snapshots automáticos"
  type        = bool
  default     = false
}

variable "enable_monitoring" {
  description = "Habilitar monitoramento"
  type        = bool
  default     = false
}

variable "timeout_seconds" {
  description = "Tempo de timeout para instalação do Helm"
  type        = number
  default     = 600
}

variable "additional_values" {
  description = "Valores adicionais para o Helm chart"
  type        = string
  default     = ""
}