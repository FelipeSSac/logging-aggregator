variable "namespace" {
  description = "Namespace onde o Fluent Bit será implantado"
  type        = string
}

variable "helm_version" {
  description = "Versão do Fluent Bit"
  type        = string
}
