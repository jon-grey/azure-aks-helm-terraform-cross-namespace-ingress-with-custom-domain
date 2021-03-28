
# helm install helm-ingress-nginx ingress-nginx/ingress-nginx \
#     --namespace $INGRESS_NAMESPACE \
#     --set controller.replicaCount=2 \
#     --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
#     --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux \
#     --set controller.admissionWebhooks.patch.nodeSelector."beta\.kubernetes\.io/os"=linux \
#     --set controller.service.loadBalancerIP="$INGRESS_PUBLIC_IP" \
#     --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-dns-label-name"="$INGRESS_DNS_LABEL" \
#     --set controller.service.externalTrafficPolicy=Local \
#     --set controller.ingressClass="$INGRESS_NAMESPACE"



resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = var.ingress_namespace
  }
}

resource "helm_release" "ingress_nginx" {
  namespace  = var.ingress_namespace
  name       = var.ingress_name 
  chart      = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx" 

# Add the ingress-nginx repository

  set {
      name  = "defaultBackend.nodeSelector\\.beta\\.kubernetes\\.io/os"
      value = "linux"
  }
  set {
      name  = "controller.nodeSelector\\.beta\\.kubernetes\\.io/os"
      value = "linux"
  }
  set {
      name  = "controller.admissionWebhooks.patch.nodeSelector\\.beta\\.kubernetes\\.io/os"
      value = "linux"
  }
  set {
      name  = "controller.replicaCount"
      value = 2
  }
  set {
      name  = "controller.service.externalTrafficPolicy"
      value = "Local"
  }
#   set { # when using FQDN and not custom domain
#       name  = "controller.service.annotations\\.service\\.beta\\.kubernetes\\.io/azure-dns-label-name"
#       value = var.ingress_controller_fqdn_dns_label
#   }
  set {
      name  = "controller.service.loadBalancerIP"
      value = var.ingress_ip_address
  }
  set {
      name  = "controller.ingressClass"
      value = var.ingress_controller_class
  }
}


