variable "project_id" {
  description = "The GCP Project ID"
  type        = string
}

variable "region" {
  description = "The primary region for resources"
  type        = string
  default     = "us-central1"

  validation {
    condition     = contains(["us-central1", "us-east1", "europe-west1", "asia-south1", "asia-east1"], var.region)
    error_message = "The region must be one of the supported GCP regions for this platform (us-central1, us-east1, europe-west1, asia-south1, asia-east1)."
  }
}

variable "database_version" {
  description = "The database version for Cloud SQL"
  type        = string
  default     = "POSTGRES_15"

  validation {
    condition     = can(regex("^POSTGRES_[0-9]+$", var.database_version)) || can(regex("^MYSQL_[0-9]+_[0-9]+$", var.database_version))
    error_message = "The database_version must start with POSTGRES_ or MYSQL_ followed by the version number."
  }
}

variable "gke_num_nodes" {
  description = "Number of GKE nodes"
  type        = number
  default     = 1

  validation {
    condition     = var.gke_num_nodes >= 1 && var.gke_num_nodes <= 10
    error_message = "The gke_num_nodes must be between 1 and 10."
  }
}

variable "gke_machine_type" {
  description = "Machine type for GKE nodes"
  type        = string
  default     = "e2-medium"
}

variable "db_tier" {
  description = "Machine tier for Cloud SQL"
  type        = string
  default     = "db-custom-2-7680"
}

variable "env" {
  description = "Environment name (e.g., prod, dev)"
  type        = string
  default     = "prod"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.env)
    error_message = "The env must be one of: dev, staging, prod."
  }
}

variable "gke_disk_size_gb" {
  description = "Size of the disk attached to each GKE node, specified in GB"
  type        = number
  default     = 50
}

variable "gke_disk_type" {
  description = "Type of the disk attached to each GKE node"
  type        = string
  default     = "pd-standard"
}

variable "db_disk_size_gb" {
  description = "Size of the Cloud SQL instance disk, specified in GB"
  type        = number
  default     = 50
}

variable "db_disk_type" {
  description = "Type of the Cloud SQL instance disk"
  type        = string
  default     = "PD_SSD"
}
