variable ingress_namespace {}
variable ingress_ip_address {}
variable ingress_controller_class {}
variable customer_id {}
variable ingress_azurerm_dns_zone {}
variable ingress_certificate_letsencrypt_name {}


# variable "email" {
#   description = "Email to be used with ClusterIssuer for CertManager"
# }
# variable "client_id" {
#   description = "Azure Kubernetes Service Cluster service principal"
# }
# variable "client_secret" {
#   description = "Azure Kubernetes Service Cluster password"
# }
# variable "location" {
#   description = "Azure resources location"
#   default = "Germany West Central"
# }
# variable "resource_group_name" {
#   description = "Azure resources group"
#   default = "aks-resource-group-demo"
# }
# variable "container_registry_name" {
#   description = "Azure container registry"
#   default = "containerregistry003"
# }
# variable "dns_prefix" {
#   description = "Azure DNS prefix"
#   default = "aks-dns-demo-000"
# }
# variable "cluster_name" {
#   description = "Azure AKS cluster name"
#   default = "aks-cluster-demo-000"
# }
# variable "agent_count" {
#     default = 1
# }
# variable "admin_username" {
#   description = "Azure AKS nodes admin account username"
#   default = "demo"
# }
# variable "default_namespace" {
#   description = "Namespace where to deploy things on K8s"
#   default     = "default"
# }

# # cert manager

# variable "cert_manager_namespace" {
#   description = "Namespace where to deploy things on K8s"
#   default     = "cert-manager-ns"
# }
# variable "cluster_issuer_letsencrypt_staging_name" {
#   default = "letsencrypt-staging"
# }
# variable "cluster_issuer_letsencrypt_prod_name" {
#   default = "letsencrypt-prod"
# }

# # ingress-nginx
# variable "ingress_name" {
#   default = "helm-ingress-nginx"
# }
# variable "ingress_namespace" {
#   default   = "ingress-nginx-ns"
# }
# variable "ingress_controller_class" {
#   default = "ingress-nginx-class"
# }
# variable "ingress_azurerm_dns_zone" {
#   default = "example.com"
# }
# variable "ingress_controller_fqdn_dns_label" {
#   default = "ingress-nginx-fqdn-dns"
# }
# variable "ingress_certificate_letsencrypt_staging_name" {
#   default = "tls-secret-staging"
# }
# variable "ingress_certificate_letsencrypt_prod_name" {
#   default = "tls-secret-staging"
# }
# variable "ingress_certificate_letsencrypt_name" {
#   default = "tls-secret-staging"
# }

# # customer app

# variable "customer_id" {
#   default = "demo000"
# }

