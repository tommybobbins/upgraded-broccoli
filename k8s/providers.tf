terraform {
  required_providers {
    aws = {
      version = ">= 3.68.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.5.1"
    }
    local = {
      version = "~> 2.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.10.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.4"
    }
  }
}

provider "google" {
  credentials = file(var.credentials_file)
  project     = var.gcpproject
  region      = var.region
}

provider "google-beta" {
  credentials = file(var.credentials_file)
  project     = var.gcpproject
  region      = var.region
}

#--------------------------------------------------------------
# Kubernetes / Helm 
#--------------------------------------------------------------

provider "kubectl" {
  ## use export KUBE_CONFIG_PATH= instead
}

provider "helm" {
  kubernetes {
  }
}

data "google_container_cluster" "primary" {
  name     = "${var.project}-gke"
  location = var.region
}

data "google_service_account" "k8s-default" {
  account_id = "object-viewer"
}

#data "google_service_account_access_token" "k8s-default" {
#  provider               = google
#  target_service_account = "service-account-k8s@${var.gcpproject}.iam.gserviceaccount.com"
#  scopes                 = ["userinfo-email", "cloud-platform"]
#  lifetime               = "300s"
#}

provider "kubernetes" {
  host           = "https://${data.google_container_cluster.primary.endpoint}"
  config_path    = "~/.kube/config"
  config_context = "gke_${var.gcpproject}_${var.region}_${var.project}-gke"
}
