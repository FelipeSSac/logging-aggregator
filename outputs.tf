output "elasticsearch_endpoint" {
  description = "Endpoint do Elasticsearch"
  value       = module.elasticsearch.endpoint
}

output "kibana_endpoint" {
  description = "Endpoint do Kibana"
  value       = module.kibana.endpoint
}