resource "kubernetes_namespace" "customer_ns" {
  metadata {
    name = "customer-${var.customer_id}-ns"
  }
}



resource "helm_release" "customer_app" {
  namespace  = "customer-${var.customer_id}-ns"
  name       = "helm-customer-${var.customer_id}-app"
  chart      = "${path.root}/helm/helm-customer-app"
  version    = "0.0.1"

  set {
    name  = "customer_id"
    value =  var.customer_id
  }
  set {
    name  = "name"
    value = "app-frontend"
  }
  set {
    name  = "registry"
    value = "mcr.microsoft.com"
  }
  set {
    name  = "image"
    value = "azuredocs/aks-helloworld"
  }
  set {
    name  = "tag"
    value = "v1"
  }
  set {
    name  = "containerPort"
    value = 80
  }
  set {
    name  = "replicas"
    value = 2
  }

  depends_on = [
      kubernetes_namespace.customer_ns,
  ]
}

