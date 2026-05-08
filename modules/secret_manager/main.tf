resource "google_secret_manager_secret" "db_password_secret" {
  secret_id = "${var.env}-boom-ott-db-password"
  project   = var.project_id

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "db_password_version" {
  secret      = google_secret_manager_secret.db_password_secret.id
  secret_data = var.db_password
}
