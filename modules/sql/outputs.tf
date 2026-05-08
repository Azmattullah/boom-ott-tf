output "instance_name" {
  value = google_sql_database_instance.primary.name
}

output "connection_name" {
  value = google_sql_database_instance.primary.connection_name
}

output "private_ip" {
  value = google_sql_database_instance.primary.private_ip_address
}

output "db_password" {
  value     = random_password.db_password.result
  sensitive = true
}
