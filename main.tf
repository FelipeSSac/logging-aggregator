resource "kubernetes_namespace" "logging" {
  metadata {
    name = var.namespace
    labels = {
      environment = var.environment
    }
  }
}

module "elasticsearch" {
  source       = "./modules/elasticsearch"

  namespace    = var.namespace
  helm_version = var.elasticsearch_version

  resource_limits = var.resource_limits
}

module "kibana" {
  source       = "./modules/kibana"
  
  namespace    = var.namespace
  helm_version = var.kibana_version
  
  environment  = var.environment
}

module "fluent_bit" {
  source       = "./modules/fluent-bit"
  
  namespace    = var.namespace
  helm_version = var.fluent_bit_version

  fluent_bit_username = var.fluent_bit_username
  fluent_bit_password = var.fluent_bit_password
}