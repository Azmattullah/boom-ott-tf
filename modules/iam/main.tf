resource "google_service_account" "gke_sa" {
  account_id   = "${var.env}-gke-node-sa"
  display_name = "Service Account for GKE nodes"
  project      = var.project_id
}

resource "google_project_iam_member" "gke_sa_roles" {
  for_each = toset([
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer"
  ])

  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.gke_sa.email}"
}

# App Workload Identity Service Account
resource "google_service_account" "workload_sa" {
  account_id   = "${var.env}-boom-ott-app-sa"
  display_name = "Workload Identity Service Account for OTT App"
  project      = var.project_id
}

# Example IAM binding for Workload Identity
# Assume KSA is 'ott-app-ksa' in 'default' namespace
resource "google_service_account_iam_binding" "workload_identity_binding" {
  service_account_id = google_service_account.workload_sa.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[default/boom-ott-app-ksa]",
  ]
}
