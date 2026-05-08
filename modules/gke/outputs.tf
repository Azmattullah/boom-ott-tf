output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "endpoint" {
  value       = google_container_cluster.primary.endpoint
  sensitive   = true
  depends_on  = [google_container_node_pool.primary_nodes]
}

output "ca_certificate" {
  value       = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
  sensitive   = true
  depends_on  = [google_container_node_pool.primary_nodes]
}
