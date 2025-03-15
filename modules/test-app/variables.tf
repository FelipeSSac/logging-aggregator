variable "namespace" {
  description = "Namespace where the test app will be deployed"
  type        = string
}

variable "log_frequency" {
  description = "How often to generate logs (in seconds)"
  type        = number
  default     = 5
}

variable "replicas" {
  description = "Number of test app replicas"
  type        = number
  default     = 1
}
