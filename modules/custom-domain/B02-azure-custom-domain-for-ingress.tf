


resource "azurerm_public_ip" "ingress" {
  name                = "ingressStaticIpName"
  resource_group_name = var.aks_cluster_node_resource_group
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  ip_version          = "IPv4"
  tags = {
    environment = "Demo"
  }
}


resource "azurerm_dns_zone" "ingress" {
  name                = var.ingress_azurerm_dns_zone
  resource_group_name = var.aks_cluster_node_resource_group
  depends_on = [
      azurerm_public_ip.ingress,
  ]

}

# az network dns record-set a add-record \
#     --resource-group myResourceGroup \
#     --zone-name MY_CUSTOM_DOMAIN \
#     --record-set-name * \
#     --ipv4-address MY_EXTERNAL_IP

# az network dns record-set a add-record \
#      --resource-group "MC_aks-resource-group-demo_aks-cluster-demo-000_germanywestcentral" \
#      --zone-name "lubiewarzywka.pl" \
#      --record-set-name '*' \
#      --ipv4-address "20.79.66.102"

resource "azurerm_dns_a_record" "ingress" {
  name                = "*"
  zone_name           = azurerm_dns_zone.ingress.name
  resource_group_name = var.aks_cluster_node_resource_group
  ttl = 300

  records = [azurerm_public_ip.ingress.ip_address]


  depends_on = [
      azurerm_dns_zone.ingress,
  ]

}