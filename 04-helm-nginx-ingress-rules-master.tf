resource "helm_release" "ingress_nginx_rules_master" {
  namespace  = var.ingress_namespace
  name       = "helm-ingress-nginx-rules-master"
  chart      = "./helm/helm-ingress-rules-master"
  version    = "0.0.1"

  set {
    name  = "ingress_master"
    value = "ingress-nginx-rules-master"
  }
  set {
    name  = "ingress_class"
    value = var.ingress_controller_class
  }
  set {
    name  = "ingress_public_url"
    value = "demo.${var.ingress_azurerm_dns_zone}"
  }
  set {
    name  = "ingress_secret_name"
    value = "tls-secret"
  }
  set {
    name  = "cert_manager_cluster_issuer"
    value = var.cluster_issuer_letsencrypt_staging_name
  }
}
