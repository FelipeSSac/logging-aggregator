# resource "kubernetes_secret" "fluent_bit_elasticsearch_creds" {
#   metadata {
#     name      = "fluent-bit-secret"
#     namespace = var.namespace
#   }

#   data = {
#     FLUENT_ELASTICSEARCH_USER     = var.fluent_bit_username
#     FLUENT_ELASTICSEARCH_PASSWORD = var.fluent_bit_password
#   }

#   type = "Opaque"
# }

# locals {
#   fluent_bit_config = templatefile("${path.module}/values.tpl", {
#     log_level       = var.log_level
#     es_host         = var.elasticsearch_host
#     es_port         = var.elasticsearch_port
#     logstash_prefix = var.logstash_prefix
#     tls_enabled     = var.tls_enabled
#   })
# }

resource "helm_release" "fluent_bit" {
  name       = "fluent-bit"
  repository = "https://fluent.github.io/helm-charts"
  chart      = "fluent-bit"
  namespace  = var.namespace
  version    = var.helm_version
  timeout    = var.timeout_seconds

  # values = [
  #   local.fluent_bit_config,
  #   var.additional_values
  # ]

  # Configurar os recursos do Fluent Bit
  # set {
  #   name  = "resources.limits.cpu"
  #   value = "500m"
  # }

  # set {
  #   name  = "resources.limits.memory"
  #   value = "512Mi"
  # }

  # set {
  #   name  = "resources.requests.cpu"
  #   value = "100m" 
  # }

  # set {
  #   name  = "resources.requests.memory"
  #   value = "128Mi"
  # }

  # # Configurar tolerations
  # set {
  #   name  = "tolerations[0].key"
  #   value = "node-role.kubernetes.io/master"
  # }

  # set {
  #   name  = "tolerations[0].operator"
  #   value = "Exists"
  # }
  
  # set {
  #   name  = "tolerations[0].effect"
  #   value = "NoSchedule"
  # }
  
  # # Configurar volume para secrets
  # set {
  #   name  = "envFrom[0].secretRef.name"
  #   value = kubernetes_secret.fluent_bit_elasticsearch_creds.metadata[0].name
  # }

  # depends_on = [kubernetes_secret.fluent_bit_elasticsearch_creds]
}

output "fluent_bit_name" {
  value = helm_release.fluent_bit.name
}
