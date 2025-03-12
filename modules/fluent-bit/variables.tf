variable "namespace" {
  description = "Namespace onde o Fluent Bit será implantado"
  type        = string
}

variable "helm_version" {
  description = "Versão do Fluent Bit"
  type        = string
}

variable "fluent_bit_username" {
  description = "Nome de usuário para autenticação no Fluent Bit"
  type        = string
}

variable "fluent_bit_password" {
  description = "Senha para autenticação no Fluent Bit"
  type        = string
}
