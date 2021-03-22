resource "helm_release" "ingress_nginx_rules_minions" {
  namespace  = var.ingress_namespace
  name       = "helm-ingress-nginx-rules-minions"
  chart      = "./helm/helm-ingress-rules-minions"
  version    = "0.0.1"
  
  set {
    name  = "ingress_class"
    value = var.ingress_controller_class
  }
  set {
    name  = "ingress_public_url"
    value = "aks-helloworld-one.${var.ingress_azurerm_dns_zone}"
  }
  set {
    name  = "frontend_name"
    value = "app-frontend"
  }
  set {
    name  = "backend_name"
    value = "app-backend"
  }
  set {
    name  = "customer_ns"
    value = "aks-helloworld-one-ns"
  }
  set {
    name  = "customer_id"
    value = "aks-helloworld-one"
  }
}

