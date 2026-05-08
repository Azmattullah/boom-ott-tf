variable "project_id" {
  description = "The GCP Project ID"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "db_password" {
  description = "The database password to store in secret manager"
  type        = string
  sensitive   = true
}
