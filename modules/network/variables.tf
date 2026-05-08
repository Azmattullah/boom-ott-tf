variable "project_id" {
  description = "The GCP Project ID"
  type        = string
}

variable "region" {
  description = "The primary region for resources"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "network_name" {
  description = "Name of the VPC network"
  type        = string
}
