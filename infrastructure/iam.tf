resource "google_service_account" "external-secrets-k8s" {
  project     = var.gcpproject
  description = "Service account able to list GCP Secret Manager secrets"
  account_id  = "external-secrets-k8s"
}

resource "google_project_iam_member" "this" {
  project = var.gcpproject
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.external-secrets-k8s.email}"
}

resource "google_service_account_iam_binding" "external-secrets-k8s" {
  service_account_id = google_service_account.external-secrets-k8s.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "serviceAccount:${var.gcpproject}.svc.id.goog[external-secrets/external-secrets]",
  ]
}
