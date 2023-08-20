resource "helm_release" "ingress_nginx" {
  count      = var.es_ingress ? 1 : 0
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "ingress-nginx"
  #set {
  #  name  = "controller.service.annotations.networking\\.gke\\.io/load-balancer-type"
  #  value = "Internal"
  #  type  = "string"
  #}
  create_namespace = "true"
  depends_on       = [kubectl_manifest.es_test]
}

resource "kubectl_manifest" "es_test_ingress" {
  count     = var.es_ingress ? 1 : 0
  yaml_body = file("helm/elasticsearch/elasticsearch_ingress.tf")
  depends_on = [
  helm_release.ingress_nginx]
}
