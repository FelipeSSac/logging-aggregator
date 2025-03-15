variable "elasticsearch_certs" {
  description = "Elasticsearch certificates for TLS authentication"
  type        = map(string)
  default     = {}
  sensitive   = true
}

resource "helm_release" "elasticsearch" {
  name       = "elasticsearch"
  repository = "https://helm.elastic.co"
  chart      = "elasticsearch"
  namespace  = var.namespace
  version    = var.helm_version

  set {
    name  = "replicas"
    value = var.resource_limits.replicas
  }

  set {
    name  = "minimumMasterNodes"
    value = var.resource_limits.replicas == "1" ? "1" : ceil(tonumber(var.resource_limits.replicas) / 2 + 0.5)
  }

  set {
    name  = "resources.limits.cpu"
    value = var.resource_limits.cpu
  }

  set {
    name  = "resources.limits.memory"
    value = var.resource_limits.memory
  }

  set {
    name  = "esJavaOpts"
    value = "-Xmx${tonumber(trimsuffix(var.resource_limits.memory, "Gi")) / 2}g -Xms${tonumber(trimsuffix(var.resource_limits.memory, "Gi")) / 2}g"
  }

  set {
    name  = "persistence.enabled"
    value = var.persistence_enabled ? "true" : "false"
  }

  set {
    name  = "volumeClaimTemplate.enabled"
    value = var.persistence_enabled ? "true" : "false"
  }

  dynamic "set" {
    for_each = var.persistence_enabled ? [1] : []
    content {
      name  = "volumeClaimTemplate.accessModes[0]"
      value = "ReadWriteOnce"
    }
  }

  dynamic "set" {
    for_each = var.persistence_enabled ? [1] : []
    content {
      name  = "volumeClaimTemplate.storageClassName"
      value = "standard"
    }
  }

  set {
    name  = "podDisruptionBudget.enabled"
    value = var.resource_limits.replicas == "1" ? "false" : "true"
  }

  set {
    name  = "security.enabled"
    value = true
  }

  set {
    name  = "security.tls.enabled"
    value = "true"
  }

  set {
    name  = "security.tls.verificationMode"
    value = "none"
  }

  set {
    name  = "security.encryption.enabled"
    value = "true"
  }

  set {
    name  = "secret.enabled"
    value = "true"
  }

  set_sensitive {
    name  = "secret.password"
    value = "elastic"
  }

  set {
    name  = "metrics.enabled"
    value = var.enable_monitoring ? "true" : "false"
  }

  set {
    name  = "metrics.serviceMonitor.enabled"
    value = var.enable_monitoring ? "true" : "false"
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "kubernetes_secret" "elasticsearch_certs" {
  metadata {
    name      = "elasticsearch-master-certs"
    namespace = var.namespace
  }

  depends_on = [helm_release.elasticsearch]
}

resource "kubernetes_service" "elasticsearch_service" {
  metadata {
    name      = "elasticsearch-master-external"
    namespace = var.namespace
    labels = {
      app = "elasticsearch-master"
    }
  }
  spec {
    selector = {
      app = "elasticsearch-master"
    }
    port {
      name        = "http"
      port        = 9200
      target_port = 9200
    }
    type = "ClusterIP"
  }
}

output "endpoint" {
  value = "http://elasticsearch-master:9200"
}

output "service_name" {
  value = "elasticsearch-master"
}

output "elasticsearch_certs" {
  value     = data.kubernetes_secret.elasticsearch_certs.data
  sensitive = true
}
