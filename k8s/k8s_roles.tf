data "google_client_config" "provider" {}

#data "google_container_cluster" "gke_cluster" {
#  name     = "${var.project}-${var.env}"
#  location = var.region
#}

module "gke_auth" {
  source               = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  project_id           = var.gcpproject
  cluster_name         = data.google_container_cluster.primary.name
  location             = var.region
  use_private_endpoint = true
  depends_on           = [data.google_container_cluster.primary]
}


resource "kubernetes_cluster_role" "restricted_role" {
  metadata {
    name = "pod-lister"
  }
  rule {
    api_groups = [""]
    resources  = ["namespaces", "pods"]
    verbs      = ["get", "list", "watch"]
  }
}
