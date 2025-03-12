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

resource "null_resource" "kibana_port_forward" {
  provisioner "local-exec" {
    command = "nohup kubectl port-forward service/kibana-${helm_release.kibana.name} 5601:5601 -n ${var.namespace} > /dev/null 2>&1 &"
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}

output "endpoint" {
  value = "http://kibana-kibana:5601"
}