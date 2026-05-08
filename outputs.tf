# ==============================================================================
# GKE Cluster Outputs
# ==============================================================================

output "gke_cluster_name" {
  value       = module.gke.cluster_name
  description = "The name of the GKE cluster"
}

output "gke_cluster_endpoint" {
  value       = module.gke.endpoint
  description = "The endpoint for the GKE cluster"
  sensitive   = true
}

output "gke_kubeconfig_command" {
  value       = "gcloud container clusters get-credentials ${module.gke.cluster_name} --region ${var.region} --project ${var.project_id}"
  description = "Run this command to configure kubectl to connect to the new cluster"
}

# ==============================================================================
# ArgoCD Outputs
# ==============================================================================

output "argocd_server_access_command" {
  value       = "kubectl port-forward svc/argocd-server -n argocd 8080:443"
  description = "Run this command to access ArgoCD UI locally at https://localhost:8080"
}

output "argocd_initial_admin_password_command" {
  value       = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath=\"{.data.password}\" | base64 -d; echo"
  description = "Run this command to get the initial admin password for ArgoCD"
}

# ==============================================================================
# Cloud SQL Outputs
# ==============================================================================

output "database_connection_name" {
  value       = module.sql.connection_name
  description = "The connection name of the Cloud SQL instance"
}

output "database_private_ip" {
  value       = module.sql.private_ip
  description = "The private IP address of the Cloud SQL instance"
}

# ==============================================================================
# App Ingress Outputs (After ArgoCD syncs)
# ==============================================================================

output "get_ingress_ip_command" {
  value       = "kubectl get ingress boom-ott-app-ingress -n boom-ott-app-ns -o jsonpath='{.status.loadBalancer.ingress[0].ip}'"
  description = "Run this command after ArgoCD deploys the app to get the public Load Balancer IP"
}
