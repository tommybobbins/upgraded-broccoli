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
