variable "alias" {
  description = "Alias for the project"
  default     = "latest"
}

variable "credentials_file" {
  description = "Google Cloud Credentials json file"
  default     = "credentials.json"
}

variable "region" {
  description = "GCP region (e.g. europe-west2"
  default     = "europe-west2"
}

variable "env" {
  description = "Environment for deployment"
  default     = "dev"
}

variable "project" {
  description = "Project name (e.g. bobbins)"
  default     = "bobbins"
}

variable "gcpproject" {
  description = "Google project name (e.g. twisted-melons-24452)"
}

#data "google_compute_zones" "available" {}

variable "es_storage_class" {
  description = "Standard Storage class for ES"
  default = {
    "sandbox" = "standard",
    "dev"     = "standard",
    "uat"     = "regionalpd-storageclass",
    "prd"     = "regionalpd-storageclass"
  }
}

variable "es_test_storage_size" {
  description = "Standard Storage class for ES"
  default = {
    "sandbox" = "1Gi",
    "dev"     = "1Gi",
    "uat"     = "200Gi", # Think about this - regionpd-storage class is minimum of 200Gi
    "prd"     = "200Gi"  # Think about this - regionpd-storage class is minimum of 200Gi
  }
}

variable "machine_type" {
  description = "Machine type for GKE"
  default     = "n2-standard-2"
}
#  n2-standard-2
#  machine_type = "e2-medium"

