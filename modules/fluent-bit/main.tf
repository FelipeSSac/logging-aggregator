resource "helm_release" "fluent_bit" {
  name       = "fluent-bit"
  repository = "https://fluent.github.io/helm-charts"
  chart      = "fluent-bit"
  namespace  = var.namespace
  version    = var.helm_version

  values = [
    <<-EOT
    config:
      service: |
        [SERVICE]
            Flush        1
            Log_Level    info
            Daemon       off
            Parsers_File parsers.conf

      inputs: |
        [INPUT]
            Name        tail
            Path        /var/log/containers/*.log
            Parser      docker
            Tag         kube.*
            Refresh_Interval 5
            
      customParsers: |
        [PARSER]
            Name        docker
            Format      json
            Time_Key    time
            Time_Format %Y-%m-%dT%H:%M:%S.%LZ

      outputs: |
        [OUTPUT]
            Name            es
            Match           *
            Host            elasticsearch-master
            Port            9200
            Logstash_Format On
            Logstash_Prefix fluent-bit
            Replace_Dots    On
            Retry_Limit     False
            tls             Off
            tls.verify      Off
            HTTP_User       ${var.fluent_bit_username}
            HTTP_Passwd     ${var.fluent_bit_password}
            Suppress_Type_Name On
    EOT
  ]

  set {
    name  = "extraVolumes[0].name"
    value = "fluent-bit-secret"
  }

  set {
    name  = "extraVolumes[0].secret.secretName"
    value = "fluent-bit-secret"
  }

  set {
    name  = "extraVolumeMounts[0].name"
    value = "fluent-bit-secret"
  }

  set {
    name  = "extraVolumeMounts[0].mountPath"
    value = "/fluent-bit-secret"
  }

  set {
    name  = "extraVolumeMounts[0].readOnly"
    value = "true"
  }
}
