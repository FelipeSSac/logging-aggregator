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
    name  = "resources.limits.cpu"
    value = var.resource_limits.cpu
  }

  set {
    name  = "resources.limits.memory"
    value = var.resource_limits.memory
  }
}

output "endpoint" {
  value = "http://elasticsearch-master:9200"
}