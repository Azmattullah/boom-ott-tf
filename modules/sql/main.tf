resource "google_sql_database_instance" "primary" {
  name             = "${var.env}-boom-ott-db-primary"
  database_version = var.database_version
  region           = var.region
  project          = var.project_id

  # Deletion protection is true by default. For learning/sandbox, we might set to false
  # but for prod it should be true.
  deletion_protection = false

  settings {
    tier              = var.db_tier
    availability_type = "REGIONAL" # High availability
    disk_size         = var.disk_size_gb
    disk_type         = var.disk_type
    disk_autoresize   = true

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network_id
    }

    backup_configuration {
      enabled                        = true
      start_time                     = "02:00"
      binary_log_enabled             = true
      transaction_log_retention_days = 7
      backup_retention_settings {
        retained_backups = 7
        retention_unit   = "COUNT"
      }
    }
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}

resource "google_sql_database" "database" {
  name     = "boom_ott_db"
  instance = google_sql_database_instance.primary.name
  project  = var.project_id
}

resource "random_password" "db_password" {
  length  = 16
  special = true
}

resource "google_sql_user" "users" {
  name     = "boom_ott_admin"
  instance = google_sql_database_instance.primary.name
  password = random_password.db_password.result
  project  = var.project_id
}
