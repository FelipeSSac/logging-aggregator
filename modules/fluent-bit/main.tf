locals {
  has_ca_cert = contains(keys(var.elasticsearch_certs), "ca.crt")
}

resource "kubernetes_secret" "fluent_bit_elasticsearch_creds" {
  metadata {
    name      = "fluent-bit-elasticsearch-certs"
    namespace = var.namespace
  }

  data = merge(
    {
      FLUENT_ELASTICSEARCH_USER     = "elastic"
      FLUENT_ELASTICSEARCH_PASSWORD = "elastic"
    },
    local.has_ca_cert ? { "ca.crt" = var.elasticsearch_certs["ca.crt"] } : {}
  )

  type = "Opaque"
}

resource "helm_release" "fluent_bit" {
  name       = "fluent-bit"
  repository = "https://fluent.github.io/helm-charts"
  chart      = "fluent-bit"
  namespace  = var.namespace
  version    = var.helm_version

  set {
    name  = "extraVolumes[0].name"
    value = "es-certs"
  }

  set {
    name  = "extraVolumes[0].secret.secretName"
    value = kubernetes_secret.fluent_bit_elasticsearch_creds.metadata[0].name
  }

  set {
    name  = "extraVolumeMounts[0].name"
    value = "es-certs"
  }

  set {
    name  = "extraVolumeMounts[0].mountPath"
    value = "/etc/fluent-bit/es-certs"
  }

  set {
    name  = "config.outputs"
    value = <<-EOT
    [OUTPUT]
        Name            es
        Match           *
        Host            ${var.elasticsearch_host}
        Port            ${var.elasticsearch_port}
        HTTP_User       ${kubernetes_secret.fluent_bit_elasticsearch_creds.data["FLUENT_ELASTICSEARCH_USER"]}
        HTTP_Passwd     ${kubernetes_secret.fluent_bit_elasticsearch_creds.data["FLUENT_ELASTICSEARCH_PASSWORD"]}
        Logstash_Format On
        Logstash_Prefix ${var.logstash_prefix}
        Replace_Dots    On
        Retry_Limit     False
        tls             True
        tls.verify      False
        tls.ca_file     /etc/fluent-bit/es-certs/ca.crt
        Suppress_Type_Name On
    EOT
  }

  depends_on = [kubernetes_secret.fluent_bit_elasticsearch_creds]
}

output "fluent_bit_name" {
  value = helm_release.fluent_bit.name
}
