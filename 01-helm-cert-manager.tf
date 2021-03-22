
resource "helm_release" "cert_manager" {
  create_namespace = true
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
}


resource "local_file" "cluster_issuer_letsencrypt_staging" {
  content = templatefile("${path.module}/templates/cluster-issuer.yaml", {
    name                = var.cluster_issuer_letsencrypt_staging_name
    server              = "https://acme-staging-v02.api.letsencrypt.org/directory"
    email               = var.email
    nodeSelector        = "linux"
    privateKeySecretRef = "letsencrypt-staging"
    namespace           = var.cert_manager_namespace
  })
  filename = "${path.module}/.files/cluster-issuer-letsencrypt-staging.yaml"
}

resource "null_resource" "cluster_issuer_letsencrypt_staging" {
  depends_on = [
    helm_release.cert_manager,
    local_file.cluster_issuer_letsencrypt_staging,
  ]

  provisioner "local-exec" {
    command = "kubectl apply --insecure-skip-tls-verify -f ./.files/cluster-issuer-letsencrypt-staging.yaml"
  }
}

resource "local_file" "cluster_issuer_letsencrypt_prod" {
  content = templatefile("${path.module}/templates/cluster-issuer.yaml", {
    name                = var.cluster_issuer_letsencrypt_prod_name
    server              = "https://acme-v02.api.letsencrypt.org/directory"
    email               = var.email
    nodeSelector        = "linux"
    privateKeySecretRef = "letsencrypt-prod"
    namespace           = var.cert_manager_namespace
  })
  filename = "${path.module}/.files/cluster-issuer-letsencrypt-prod.yaml"
}

resource "null_resource" "cluster_issuer_letsencrypt_prod" {
  depends_on = [
    helm_release.cert_manager,
    local_file.cluster_issuer_letsencrypt_prod,
  ]

  provisioner "local-exec" {
    command = "kubectl apply --insecure-skip-tls-verify -f ./.files/cluster-issuer-letsencrypt-prod.yaml"
  }
}