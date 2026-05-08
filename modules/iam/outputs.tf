output "gke_service_account_email" {
  value = google_service_account.gke_sa.email
}

output "workload_identity_sa_email" {
  value = google_service_account.workload_sa.email
}
