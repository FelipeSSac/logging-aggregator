resource "helm_release" "kibana" {
  name       = "kibana"
  repository = "https://helm.elastic.co"
  chart      = "kibana"
  namespace  = var.namespace
  version    = var.helm_version
  
  set {
    name  = "service.type"
    value = var.environment == "prod" ? "LoadBalancer" : "ClusterIP"
  }
}

output "endpoint" {
  value = "http://kibana-kibana:5601"
}