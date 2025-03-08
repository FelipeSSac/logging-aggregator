resource "helm_release" "fluent_bit" {
  name       = "fluent-bit"
  repository = "https://fluent.github.io/helm-charts"
  chart      = "fluent-bit"
  namespace  = var.namespace
  version    = var.helm_version 

  set {
    name  = "nodeSelector.node-pool"
    value = var.node_pool
  }

  values = [
    <<-EOT
    config:
      outputs: |
        [OUTPUT]
            Name  es
            Match *
            Host  elasticsearch-master
            Port  9200
            Logstash_Format On
            Logstash_Prefix fluent-bit
    EOT
  ]
}