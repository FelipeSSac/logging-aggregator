variable "namespace" {
  description = "Namespace onde o Fluent Bit será implantado"
  type        = string
}

variable "helm_version" {
  description = "Versão do Fluent Bit"
  type        = string
}

variable "elasticsearch_host" {
  description = "Host do Elasticsearch"
  type        = string
  default     = "elasticsearch-master"
}

variable "elasticsearch_port" {
  description = "Porta do Elasticsearch"
  type        = string
  default     = "9200"
}

variable "log_level" {
  description = "Nível de log do Fluent Bit"
  type        = string
  default     = "info"
}

variable "tls_enabled" {
  description = "Habilitar TLS para conexão com Elasticsearch"
  type        = bool
  default     = false
}

variable "logstash_prefix" {
  description = "Prefixo para índices do Logstash"
  type        = string
  default     = "fluent-bit"
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
