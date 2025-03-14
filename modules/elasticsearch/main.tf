resource "helm_release" "elasticsearch" {
  name       = "elasticsearch"
  repository = "https://helm.elastic.co"
  chart      = "elasticsearch"
  namespace  = var.namespace
  version    = var.helm_version
  # timeout    = var.timeout_seconds

  # values = [
  #   file("${path.module}/values.yaml"),
  #   var.additional_values
  # ]

  # Configurações básicas
  set {
    name  = "replicas"
    value = var.resource_limits.replicas
  }

  set {
    name  = "minimumMasterNodes"
    value = var.resource_limits.replicas == "1" ? "1" : ceil(tonumber(var.resource_limits.replicas) / 2 + 0.5)
  }

  # Configurações de recursos
  set {
    name  = "resources.limits.cpu"
    value = var.resource_limits.cpu
  }

  set {
    name  = "resources.limits.memory"
    value = var.resource_limits.memory
  }

  # set {
  #   name  = "resources.requests.cpu"
  #   value = var.enable_requests ? format("%sm", max(500, tonumber(trimsuffix(var.resource_limits.cpu, "m")) / 2)) : "100m"
  # }

  # set {
  #   name  = "resources.requests.memory"
  #   value = var.enable_requests ? format("%s", max("512Mi", var.resource_limits.memory)) : "256Mi"
  # }

  # # Configurações de Java
  # set {
  #   name  = "esJavaOpts"
  #   value = "-Xmx${tonumber(trimsuffix(var.resource_limits.memory, "Gi")) / 2}g -Xms${tonumber(trimsuffix(var.resource_limits.memory, "Gi")) / 2}g"
  # }

  # # Configurações de persistência
  # set {
  #   name  = "persistence.enabled"
  #   value = var.persistence_enabled ? "true" : "false"
  # }

  # set {
  #   name  = "volumeClaimTemplate.enabled"
  #   value = var.persistence_enabled ? "true" : "false"
  # }

  # dynamic "set" {
  #   for_each = var.persistence_enabled ? [1] : []
  #   content {
  #     name  = "volumeClaimTemplate.accessModes[0]"
  #     value = "ReadWriteOnce"
  #   }
  # }

  # dynamic "set" {
  #   for_each = var.persistence_enabled ? [1] : []
  #   content {
  #     name  = "volumeClaimTemplate.storageClassName"
  #     value = "standard"
  #   }
  # }

  # dynamic "set" {
  #   for_each = var.persistence_enabled ? [1] : []
  #   content {
  #     name  = "volumeClaimTemplate.resources.requests.storage"
  #     value = var.storage_size
  #   }
  # }

  # # Configurações de segurança
  # set {
  #   name  = "antiAffinity"
  #   value = "soft"
  # }

  set {
    name  = "podDisruptionBudget.enabled"
    value = var.resource_limits.replicas == "1" ? "false" : "true"
  }

  set {
    name  = "xpack.security.enabled"
    value = "false"
  }

  set {
    name  = "xpack.security.transport.ssl.enabled"
    value = "false"
  }

  set {
    name  = "xpack.security.http.ssl.enabled"
    value = "false"
  }

  set {
    name = "xpack.security.enrollment.enabled" 
    value = "false"
  }

  # set {
  #   name  = "imageTag"
  #   value = "8.10.0"
  # }

  # # Configurações explícitas de segurança
  set {
    name  = "security.enabled"
    value = "false"  # Changed from true to false
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

  # Add these set blocks for password configuration
  set {
    name  = "secret.enabled"
    value = "true"
  }

  set_sensitive {
    name  = "secret.password"
    value = "elastic"
  }
  
  # # Monitoramento
  # set {
  #   name  = "metrics.enabled"
  #   value = var.enable_monitoring ? "true" : "false"
  # }

  # set {
  #   name  = "metrics.serviceMonitor.enabled"
  #   value = var.enable_monitoring ? "true" : "false"
  # }
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
