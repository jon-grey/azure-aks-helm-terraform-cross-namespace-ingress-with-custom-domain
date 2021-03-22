variable "email" {
  default = "robgrzelka@gmail.com"

}


variable "client_id" {
  description = "Azure Kubernetes Service Cluster service principal"
}

variable "client_secret" {
  description = "Azure Kubernetes Service Cluster password"
}

variable "location" {
  description = "Azure resources location"
  default = "Germany West Central"
}

variable "resource_group_name" {
  description = "Azure resources group"
  default = "aks-resource-group-demo-010"
}

variable "dns_prefix" {
  description = "Azure DNS prefix"
  default = "aks-dns-demo-010"
}

variable "cluster_name" {
  description = "Azure AKS cluster name"
  default = "aks-cluster-demo-010"
}

variable "agent_count" {
    default = 3
}

variable "admin_username" {
    default = "demo"
}



variable "default_namespace" {
  description = "Namespace where to deploy things on K8s"
  default     = "default"
}

# cert manager

variable "cert_manager_namespace" {
  description = "Namespace where to deploy things on K8s"
  default     = "cert-manager"
}


variable "cluster_issuer_letsencrypt_staging_name" {
  default = "letsencrypt-staging-clis"
}

variable "cluster_issuer_letsencrypt_prod_name" {
  default = "letsencrypt-prod-clis"
}

# ingress-nginx

variable "ingress_name" {
  default = "helm-ingress-nginx"
}

variable "ingress_namespace" {
  default   = "ingress-nginx-ns"
}

variable "ingress_controller_class" {
  default = "ingress-nginx-class"
}

variable "ingress_azurerm_dns_zone" {
  default = "lubiewarzywka.pl"
}

variable "ingress_controller_fqdn_dns_label" {
  default = "ingress-nginx-fqdn-dns"
}

