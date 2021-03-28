output "resource_group_name" {
  value = azurerm_resource_group.k8s.name
}

# output "kubernetes_cluster_name" {
#   value = azurerm_kubernetes_cluster.k8s.name
# }

# output "host" {
#   value = azurerm_kubernetes_cluster.k8s.kube_config.0.host
# }

# output "client_key" {
#   value = azurerm_kubernetes_cluster.k8s.kube_config.0.client_key
# }

# output "client_certificate" {
#   value = azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate
# }

# output "cluster_ca_certificate" {
#     value = azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate
# }

output "kube_config" {
  value = module.a_aks_cluster.kube_config
}

# output "cluster_username" {
#   value = azurerm_kubernetes_cluster.k8s.kube_config.0.username
# }

# output "cluster_password" {
#   value = azurerm_kubernetes_cluster.k8s.kube_config.0.password
# }

# output "node_resource_group" {
#   value = azurerm_kubernetes_cluster.k8s.node_resource_group
# }

output "configure" {
  value = <<CONFIGURE

Run the following commands to configure kubernetes client:

```sh
terraform output -raw kube_config > ~/.kube/aksconfig
export KUBECONFIG=~/.kube/aksconfig
```

Test configuration using kubectl
```sh
kubectl get nodes
```

CONFIGURE
}