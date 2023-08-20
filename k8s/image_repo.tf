resource "google_artifact_registry_repository" "benchmarking" {
  location      = var.region
  repository_id = "benchmarking"
  description   = "Opensearch/Elasticsearch Benchmark repository"
  format        = "Docker"
}

resource "google_artifact_registry_repository_iam_member" "benchmark" {
  provider   = google-beta
  location   = google_artifact_registry_repository.benchmarking.location
  repository = google_artifact_registry_repository.benchmarking.name
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:service-account-k8s@${var.gcpproject}.iam.gserviceaccount.com"
}
