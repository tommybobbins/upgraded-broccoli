variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  default     = ""
  description = "gke password"
}

variable "gke_num_nodes" {
  default     = 1
  description = "number of gke nodes"
}

resource "google_service_account" "k8s-default" {
  account_id   = "service-account-k8s"
  display_name = "k8s Service Account"
}


# GKE cluster
resource "google_container_cluster" "primary" {
  name     = "${var.project}-gke"
  location = var.region

  initial_node_count = 1
  enable_autopilot   = false
  network            = google_compute_network.vpc.name
  subnetwork         = google_compute_subnetwork.subnet.name

  dns_config {
    cluster_dns       = "CLOUD_DNS"
    cluster_dns_scope = "CLUSTER_SCOPE"
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "10.96.0.0/14"
    services_ipv4_cidr_block = "10.192.0.0/16"
  }
  #  n2-standard-2
  #  machine_type = "e2-medium"
  node_config {
    disk_size_gb    = 150
    spot            = true
    machine_type    = var.machine_type
    service_account = google_service_account.k8s-default.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

data "google_client_config" "default" {
  depends_on = [google_container_cluster.primary]
}

#data "google_container_cluster" "primary" {
#  name       = "${var.project}-gke"
#  location   = var.region
#  depends_on = [google_container_cluster.primary]
#}

#provider "kubernetes" {
#  host                   = "https://${google_container_cluster.primary.endpoint}"
#  token                  = data.google_client_config.default.access_token
#  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
#}

