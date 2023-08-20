
resource "helm_release" "external-secrets" {
  name             = "external-secrets"
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  namespace        = "external-secrets"
  create_namespace = true
  timeout          = 600
  values = [templatefile("helm/external-secrets/overrides.yaml", {
    service_account = "external-secrets-k8s@${var.gcpproject}.iam.gserviceaccount.com"
  })]
  depends_on = [
    helm_release.elastic_operator // helm release must exist to build elasticsearch
  ]
}

resource "time_sleep" "external_secrets" {
  depends_on = [
    helm_release.external-secrets
  ]
  create_duration = "60s" // wait 60 seconds after helm chart completion for loadbalancer to come up
}


resource "kubectl_manifest" "cluster_secretstore" {
  yaml_body = templatefile("helm/external-secrets/cluster_secretstore.yaml", {
    zproject = var.project,
    env      = var.env,
    region   = var.region,
    project  = var.gcpproject
  })
  depends_on = [
    time_sleep.external_secrets
  ]
}


