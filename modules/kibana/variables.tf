variable "namespace" {
  description = "Namespace onde o Kibana será implantado"
  type        = string
}

variable "helm_version" {
  description = "Versão do Kibana"
  type        = string
}

variable "environment" {
  description = "Nome do ambiente (dev, staging, prod, etc.)"
  type        = string
  default     = "dev"
}

variable "resource_limits" {
  description = "Limites de recursos para os pods do Kibana"
  type = object({
    cpu      = string
    memory   = string
  })
  default = {
    cpu      = "500m"
    memory   = "512Mi"
  }
}

variable "enable_requests" {
  description = "Habilitar requests de recursos"
  type        = bool
  default     = true
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