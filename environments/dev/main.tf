module "logging" {
  source                = "../../"

  namespace             = var.namespace
  environment           = var.environment
  elasticsearch_version = var.elasticsearch_version
  kibana_version        = var.kibana_version
  fluent_bit_version    = var.fluent_bit_version
  resource_limits       = var.resource_limits 
  fluent_bit_username   = var.fluent_bit_username
  fluent_bit_password   = var.fluent_bit_password
}