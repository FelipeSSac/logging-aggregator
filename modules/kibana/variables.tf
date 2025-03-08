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