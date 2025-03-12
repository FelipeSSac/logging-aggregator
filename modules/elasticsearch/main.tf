resource "helm_release" "elasticsearch" {
  name       = "elasticsearch"
  repository = "https://helm.elastic.co"
  chart      = "elasticsearch"
  namespace  = var.namespace
  version    = var.helm_version

  values = [
    file("${path.module}/values.yaml")
  ]

  set {
    name  = "replicas"
    value = "1"
  }

  set {
    name  = "minimumMasterNodes"
    value = "1"
  }

  set {
    name  = "resources.limits.cpu"
    value = "1000m"
  }

  set {
    name  = "resources.limits.memory"
    value = "2Gi"
  }

  set {
    name  = "podDisruptionBudget.enabled"
    value = "false"
  }

  set {
    name  = "volumeClaimTemplate.enabled"
    value = "false"
  }

  set {
    name  = "imageTag"
    value = "8.10.0"
  }

  set {
    name  = "esJavaOpts"
    value = "-Xmx1g -Xms1g"
  }

  # Adicionar configurações explícitas de segurança
  set {
    name  = "antiAffinity"
    value = "soft"
  }

  set {
    name  = "security.enabled"
    value = "false"
  }

  set {
    name  = "security.tls.enabled"
    value = "false"
  }

  set {
    name  = "security.tls.verificationMode"
    value = "none"
  }

  set {
    name  = "security.encryption.enabled"
    value = "false"
  }

  set {
    name  = "security.http.ssl.enabled"
    value = "false"
  }

  set {
    name  = "security.transport.ssl.enabled"
    value = "false"
  }

  set {
    name  = "volumeClaimTemplate.accessModes[0]"
    value = "ReadWriteOnce"
  }

  set {
    name  = "volumeClaimTemplate.storageClassName"
    value = "standard"
  }

  set {
    name  = "volumeClaimTemplate.resources.requests.storage"
    value = "10Gi"
  }

  set {
    name  = "persistence.enabled"
    value = "false"
  }

  set {
    name  = "resources.requests.memory"
    value = "2Gi"
  }

  set {
    name  = "resources.requests.cpu"
    value = "1000m"
  }
}

output "endpoint" {
  value = "http://elasticsearch-master:9200"
}
