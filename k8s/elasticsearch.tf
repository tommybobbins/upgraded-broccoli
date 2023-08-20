resource "kubernetes_namespace" "es_test" {
  metadata {
    name = "es-test"
  }
  depends_on = [data.google_container_cluster.primary]
}

resource "helm_release" "elastic_operator" {
  name             = "elastic-operator"
  repository       = "https://helm.elastic.co"
  chart            = "eck-operator"
  namespace        = "elastic-system"
  create_namespace = "true"
  depends_on       = [kubernetes_namespace.es_test]
}

resource "kubectl_manifest" "es_test" {
  yaml_body = templatefile("helm/elasticsearch/elasticsearch-manifest.yml", {
    name          = "test",
    project       = "${var.project}",
    nodesets      = "1",
    storage_class = "${lookup(var.es_storage_class, var.env)}",
    storage_size  = "${lookup(var.es_test_storage_size, var.env)}"
  })
  depends_on = [
    helm_release.elastic_operator // helm release must exist to build elasticsearch
  ]
}

data "kubernetes_secret" "es_test" {
  metadata {
    namespace = "es-test"
    name      = "es-elastic-user"
  }
  binary_data = {
    elastic = ""
  }
  depends_on = [kubectl_manifest.es_test]
}

resource "google_secret_manager_secret" "es_test" {
  secret_id = "elasticsearch-test"
  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
  depends_on = [kubectl_manifest.es_test]
}

resource "google_secret_manager_secret_version" "es_test" {
  secret      = google_secret_manager_secret.es_test.id
  secret_data = jsonencode(data.kubernetes_secret.es_test.binary_data)
}

