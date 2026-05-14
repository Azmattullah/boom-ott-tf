# Network Module
module "network" {
  source       = "./modules/network"
  project_id   = var.project_id
  region       = var.region
  env          = var.env
  network_name = "${var.env}-boom-ott-vpc"
}

# IAM Module
module "iam" {
  source     = "./modules/iam"
  project_id = var.project_id
  env        = var.env
}

# GKE Module
module "gke" {
  source             = "./modules/gke"
  project_id         = var.project_id
  region             = var.region
  env                = var.env
  network            = module.network.network_name
  subnetwork         = module.network.subnet_name
  cluster_name       = "${var.env}-boom-ott-cluster"
  service_account    = module.iam.gke_service_account_email
  initial_node_count = var.gke_num_nodes
  machine_type       = var.gke_machine_type
  disk_size_gb       = var.gke_disk_size_gb
  disk_type          = var.gke_disk_type
  master_ipv4_cidr   = "172.16.0.0/28"
  depends_on         = [module.network]
}

# Cloud SQL Module
module "sql" {
  source           = "./modules/sql"
  project_id       = var.project_id
  region           = var.region
  env              = var.env
  database_version = var.database_version
  db_tier          = var.db_tier
  disk_size_gb     = var.db_disk_size_gb
  disk_type        = var.db_disk_type
  network_id       = module.network.network_id
  db_name          = "${var.env}-boom-ott-db"
  depends_on       = [module.network]
}

# Secret Manager Module
module "secret_manager" {
  source      = "./modules/secret_manager"
  project_id  = var.project_id
  env         = var.env
  db_password = module.sql.db_password
}

data "google_client_config" "default" {}

data "google_container_cluster" "primary" {
  name     = module.gke.cluster_name
  location = var.region
  project  = var.project_id
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.primary.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = "https://${data.google_container_cluster.primary.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
  }
}

# ArgoCD Module
module "argocd" {
  source     = "./modules/argocd"
  depends_on = [module.gke]
}
