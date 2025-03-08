variable "namespace" {
  description = "Namespace onde o Fluent Bit será implantado"
  type        = string
}

variable "helm_version" {
  description = "Versão do Fluent Bit"
  type        = string
}

variable "node_pool" {
  description = "Node pool onde os recursos serão implantados no ambiente de desenvolvimento"
  type        = string
  default     = "default-pool"
}