

resource "azurerm_public_ip" "ingress" {
  name                = "ingressStaticIpName"
  resource_group_name = azurerm_kubernetes_cluster.k8s.node_resource_group
  location            = azurerm_resource_group.k8s.location
  allocation_method   = "Static"
  sku                 = "Standard"
  ip_version          = "IPv4"
  tags = {
    environment = "Demo"
  }
}


resource "azurerm_dns_zone" "ingress" {
  name                = var.ingress_azurerm_dns_zone
  resource_group_name = azurerm_kubernetes_cluster.k8s.node_resource_group
}

# az network dns record-set a add-record \
#     --resource-group myResourceGroup \
#     --zone-name MY_CUSTOM_DOMAIN \
#     --record-set-name * \
#     --ipv4-address MY_EXTERNAL_IP

resource "azurerm_dns_a_record" "ingress" {
  name                = "*"
  zone_name           = azurerm_dns_zone.ingress.name
  resource_group_name = azurerm_kubernetes_cluster.k8s.node_resource_group
  ttl = 300

  records = [azurerm_public_ip.ingress.ip_address]

}