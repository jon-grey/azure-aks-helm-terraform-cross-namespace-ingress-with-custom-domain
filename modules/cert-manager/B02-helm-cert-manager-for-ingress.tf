

resource "kubernetes_namespace" "cert_manager" {
  metadata {
    labels = {
      "certmanager.k8s.io/disable-validation" = "true"
    }
    name = var.cert_manager_namespace
  }
}

resource "helm_release" "cert_manager" {
  namespace  = var.cert_manager_namespace
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "1.2.0"

  set {
    name  = "installCRDs"
    value = "true"
  }
  set {
    name  = "nodeSelector\\.beta\\.kubernetes\\.io/os"
    value = "linux"
  }

  depends_on = [
    kubernetes_namespace.cert_manager
  ]

}

resource "helm_release" "lets_encrypt_cluster_issuer_staging" {
  name       = "helm-letsencrypt-cluster-issuer-staging"
  chart      = "${path.root}/helm/helm-letsencrypt-cluster-issuer"
  version    = "0.0.1"

  set {
    name  = "cluster_issuer_letsencrypt_name"
    value = var.cluster_issuer_letsencrypt_staging_name
  }
  set {
    name  = "private_key_secret_ref"
    value = var.cluster_issuer_letsencrypt_staging_name
  }
  set {
    name  = "lets_encrypt_server_url"
    value = "https://acme-staging-v02.api.letsencrypt.org/directory"
  }
  set {
    name  = "email"
    value = var.email
  }
  set {
    name  = "ingress_controller_class"
    value = var.ingress_controller_class
  }

  depends_on = [
    helm_release.cert_manager
  ]
}

# resource "helm_release" "lets_encrypt_cert_staging" {
#   namespace  = var.ingress_namespace
#   name       = "helm-letsencrypt-cert-staging"
#   chart      = "${path.root}/helm/helm-letsencrypt-cert"
#   version    = "0.0.1"

#   set {
#     name  = "private_key_secret_ref"
#     value = var.cluster_issuer_letsencrypt_staging_name
#   }
#   set {
#     name  = "certificate_letsencrypt_name"
#     value = var.ingress_certificate_letsencrypt_staging_name
#   }
#   set {
#     name  = "domain_name"
#     value = var.ingress_azurerm_dns_zone
#   }
  
#   depends_on = [
#     kubernetes_namespace.ingress,
#     helm_release.lets_encrypt_cluster_issuer_staging,
#   ]
# }



# resource "helm_release" "lets_encrypt_cluster_issuer_prod" {
#   name       = "helm-letsencrypt-cluster-issuer-prod"
#   chart      = "./helm/helm-letsencrypt-cluster-issuer"
#   version    = "0.0.1"

#   set {
#     name  = "cluster_issuer_letsencrypt_name"
#     value = var.cluster_issuer_letsencrypt_prod_name
#   }
#   set {
#     name  = "cert_manager_namespace"
#     value = var.cert_manager_namespace
#   }
#   set {
#     name  = "lets_encrypt_server_url"
#     value = "https://acme-v02.api.letsencrypt.org/directory"
#   }
#   set {
#     name  = "private_key_secret_ref"
#     value = "letsencrypt-prod"
#   }
#   set {
#     name  = "ingress_controller_class"
#     value = var.ingress_controller_class
#   }
#   set {
#     name  = "certificate_letsencrypt_name"
#     value = var.ingress_certificate_letsencrypt_prod_name
#   }
#   set {
#     name  = "ingress_namespace"
#     value = var.ingress_namespace
#   }
#   set {
#     name  = "domain_name"
#     value = var.ingress_azurerm_dns_zone
#   }
# }


