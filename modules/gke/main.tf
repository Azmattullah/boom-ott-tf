resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region
  node_locations = ["${var.region}-a"]
  project  = var.project_id

  deletion_protection = false

  network    = var.network
  subnetwork = var.subnetwork

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  node_config {
    disk_type    = var.disk_type
    disk_size_gb = var.disk_size_gb
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = var.master_ipv4_cidr
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "gke-pods"
    services_secondary_range_name = "gke-services"
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0"
      display_name = "All"
    }
  }

  release_channel {
    channel = "REGULAR"
  }

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name     = "${var.cluster_name}-node-pool"
  location = var.region
  node_locations = ["${var.region}-a"]
  cluster  = google_container_cluster.primary.name
  project  = var.project_id

  initial_node_count = var.initial_node_count

  autoscaling {
    min_node_count = 1
    max_node_count = 5
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    service_account = var.service_account
    machine_type    = var.machine_type
    disk_size_gb    = var.disk_size_gb
    disk_type       = var.disk_type

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    labels = {
      env = var.env
    }
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}
