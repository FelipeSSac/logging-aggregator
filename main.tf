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
  source          = "./modules/elasticsearch"
  namespace       = kubernetes_namespace.logging.metadata[0].name
  helm_version    = var.elasticsearch_version
  resource_limits = var.resource_limits
  
  persistence_enabled = var.persistence_enabled
  enable_monitoring   = var.enable_monitoring
  
  # Valores adicionais podem ser passados como string
  additional_values = ""
}

# Módulo Kibana
# module "kibana" {
#   source       = "./modules/kibana"
#   namespace    = kubernetes_namespace.logging.metadata[0].name
#   helm_version = var.kibana_version
#   environment  = var.environment
  
#   resource_limits = {
#     cpu    = var.resource_limits.cpu
#     memory = var.resource_limits.memory
#   }
  
#   # Depende do Elasticsearch estar pronto
#   depends_on = [module.elasticsearch]
# }

# Módulo Fluent Bit
module "fluent_bit" {
  source             = "./modules/fluent-bit"
  namespace          = kubernetes_namespace.logging.metadata[0].name
  helm_version       = var.fluent_bit_version
  
  # Configuração do Elasticsearch
  elasticsearch_host = module.elasticsearch.service_name
  elasticsearch_port = "9200"
  
  logstash_prefix = "k8s"
  # Desativar TLS em ambiente de desenvolvimento
  tls_enabled        = var.environment == "dev" ? false : true
  
  # Depende do Elasticsearch estar pronto
  depends_on = [module.elasticsearch]
}