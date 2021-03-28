resource "helm_release" "ingress_nginx_rules_minions" {
  namespace  = var.ingress_namespace
  name       = "helm-customer-${var.customer_id}-ingress-nginx-rules-minions"
  chart      = "${path.root}/helm/helm-ingress-rules-minions"
  version    = "0.0.1"
  
  set {
    name  = "ingress_class"
    value = var.ingress_controller_class
  }
  set {
    name  = "ingress_public_url"
    value = "${var.customer_id}.${var.ingress_azurerm_dns_zone}"
  }
  set {
    name  = "app_name"
    value = "app-frontend"
  }
  set {
    name  = "customer_ns"
    value = var.customer_ns
  }
  set {
    name  = "customer_id"
    value = var.customer_id
  }
  set {
    name  = "app_container_port"
    value = 80
  }

}



