resource "helm_release" "kibana" {
  name       = "kibana"
  repository = "https://helm.elastic.co"
  chart      = "kibana"
  namespace  = var.namespace
  version    = var.helm_version
  timeout    = 600

  cleanup_on_fail = true
  atomic          = true
  force_update    = true
  recreate_pods   = true

  # Configuração do Elasticsearch
  set {
    name  = "elasticsearchHosts"
    value = "https://elasticsearch-master:9200"
  }

  # Set Elasticsearch credentials
  # set {
  #   name  = "elasticsearch.username"
  #   value = "elastic" # Default Elasticsearch user
  # }

  # set_sensitive {
  #   name  = "elasticsearch.password"
  #   value = "elastic" # Same password as set in Elasticsearch
  # }

  set {
    name  = "wait.enabled"
    value = "true"
  }

  set {
    name  = "wait.forHealthyStatusTimeout"
    value = "300"
  }

  # set {
  #   name  = "extraEnvs[0].name"
  #   value = "ELASTICSEARCH_USERNAME"
  # }

  # set {
  #   name  = "extraEnvs[0].value"
  #   value = "elastic"
  # }

  # set {
  #   name  = "extraEnvs[1].name"
  #   value = "ELASTICSEARCH_PASSWORD"
  # }

  # set_sensitive {
  #   name  = "extraEnvs[1].value"
  #   value = "elastic"
  # }

  # set {
  #   name  = "kibanaConfig.kibana\\.yml"
  #   value = <<EOT
  #     elasticsearch.hosts: ["https://elasticsearch-master:9200"]
  #     elasticsearch.username: elastic
  #     elasticsearch.password: elastic
  #     elasticsearch.ssl.verificationMode: none
  #     xpack.security.enabled: true
  #     server.host: "0.0.0.0"
  #   EOT
  # }

  # Disable token creation hooks since you're using basic auth
  # set {
  #   name  = "createToken.enabled"
  #   value = "false" # Disable the token creation that's failing
  # }
}

output "endpoint" {
  value = "http://kibana-kibana:5601"
}

resource "kubernetes_service" "kibana_service" {
  count = var.environment == "prod" ? 1 : 0

  metadata {
    name      = "kibana-external"
    namespace = var.namespace
    labels = {
      app = "kibana"
    }
  }
  spec {
    selector = {
      app = "kibana"
    }
    port {
      name        = "http"
      port        = 5601
      target_port = 5601
    }
    type = "LoadBalancer"
  }
}

resource "kubernetes_service" "kibana_nodeport" {
  count = var.environment == "dev" ? 1 : 0

  metadata {
    name      = "kibana-nodeport"
    namespace = var.namespace
    labels = {
      app = "kibana"
    }
  }
  spec {
    selector = {
      app = "kibana-kibana"
    }
    port {
      name        = "http"
      port        = 5601
      target_port = 5601
      node_port   = 30601
    }
    type = "NodePort"
  }

  depends_on = [helm_release.kibana]
}
