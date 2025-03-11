module "logging" {
  source                = "../../"

  namespace             = var.namespace
  environment           = var.environment
  elasticsearch_version = var.elasticsearch_version
  kibana_version        = var.kibana_version
  fluent_bit_version    = var.fluent_bit_version
  resource_limits       = var.resource_limits 
}