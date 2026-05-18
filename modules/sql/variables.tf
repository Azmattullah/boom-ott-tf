variable "project_id" {
  description = "The GCP Project ID"
  type        = string
}

variable "region" {
  description = "The region for the Cloud SQL instance"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "database_version" {
  description = "The database version (e.g., MYSQL_8_0)"
  type        = string
}

variable "db_tier" {
  description = "The tier of the database instance"
  type        = string
}

variable "network_id" {
  description = "The VPC Network ID for private IP connectivity"
  type        = string
}

variable "db_name" {
  description = "The name of the database"
  type        = string
}

variable "disk_size_gb" {
  description = "Size of the Cloud SQL instance disk, specified in GB"
  type        = number
  default     = 50
}

variable "disk_type" {
  description = "Type of the Cloud SQL instance disk"
  type        = string
  default     = "PD_SSD"
}
