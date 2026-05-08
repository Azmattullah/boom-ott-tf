output "secret_id" {
  value = google_secret_manager_secret.db_password_secret.id
}

output "secret_name" {
  value = google_secret_manager_secret.db_password_secret.name
}
