variable "project_id" {
  description = "The GCP Project ID"
  type        = string
}

variable "region" {
  description = "The region for the GKE cluster"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "network" {
  description = "The VPC network name"
  type        = string
}

variable "subnetwork" {
  description = "The subnetwork name"
  type        = string
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
}

variable "service_account" {
  description = "The service account to run nodes as"
  type        = string
}

variable "initial_node_count" {
  description = "Initial number of nodes for the default pool"
  type        = number
  default     = 1
}

variable "machine_type" {
  description = "Machine type for the node pool"
  type        = string
}

variable "master_ipv4_cidr" {
  description = "The /28 CIDR block for the GKE master nodes"
  type        = string
}

variable "disk_size_gb" {
  description = "Size of the disk attached to each node, specified in GB"
  type        = number
  default     = 50

  validation {
    condition     = var.disk_size_gb <= 100
    error_message = "The disk size must be 100 GB or less to avoid exceeding the SSD_TOTAL_GB quota."
  }
}

variable "disk_type" {
  description = "Type of the disk attached to each node"
  type        = string
  default     = "pd-standard"
}
