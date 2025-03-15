resource "kubernetes_namespace" "logging" {
  metadata {
    name = var.namespace
    labels = {
      environment = var.environment
    }
  }
}

# Módulo Elasticsearch
module "elasticsearch" {
  source = "./modules/elasticsearch"

  namespace       = var.namespace
  helm_version    = var.elasticsearch_version
  resource_limits = var.es_resource_limits

  environment = var.environment
  # tls_enabled = var.environment == "dev" ? false : true
  tls_enabled = true

  persistence_enabled = var.persistence_enabled
  enable_monitoring   = var.enable_monitoring
}

# Módulo Kibana
module "kibana" {
  source       = "./modules/kibana"
  namespace    = kubernetes_namespace.logging.metadata[0].name
  helm_version = var.kibana_version
  environment  = var.environment

  # Depende do Elasticsearch estar pronto
  depends_on = [module.elasticsearch]
}

# Módulo Fluent Bit
module "fluent_bit" {
  source = "./modules/fluent-bit"

  namespace    = var.namespace
  helm_version = var.fluent_bit_version

  elasticsearch_host = module.elasticsearch.service_name
  elasticsearch_port = "9200"

  logstash_prefix = "k8s"
  # tls_enabled     = var.environment == "dev" ? false : true
  tls_enabled = true

  elasticsearch_certs = module.elasticsearch.elasticsearch_certs

  depends_on = [module.elasticsearch]
}

module "test_app" {
  source = "./modules/test-app"

  namespace     = var.namespace
  log_frequency = 5 # Generate logs every 5 seconds
  replicas      = 1 # Deploy 1 pod

  depends_on = [
    module.elasticsearch,
    module.fluent_bit
  ]
}
