
#######################################################################################
#### STAGE C 1.1 - Deploy customer app
#######################################################################################

module "c_customer_app" {
  source = "../customer-app"

  customer_id = var.customer_id

}

#######################################################################################
#### STAGE C 1.1 - Deploy customer nginx rules master
#######################################################################################

module "c_customer_ingress_rules_master" {
  source = "../ingress-rules-master"

  customer_id = var.customer_id

  ingress_namespace = var.ingress_namespace
  ingress_controller_class = var.ingress_controller_class
  ingress_azurerm_dns_zone = var.ingress_azurerm_dns_zone
  ingress_certificate_letsencrypt_name = var.ingress_certificate_letsencrypt_name
  ingress_ip_address = var.ingress_ip_address

}

#######################################################################################
#### STAGE C 2.0 - Deploy customer nginx rules minions (for mergeable updates of rules)
#######################################################################################

module "c_customer_ingress_rules_minions" {
  source = "../ingress-rules-minions"
  
  customer_id = var.customer_id

  ingress_namespace = var.ingress_namespace
  ingress_controller_class = var.ingress_controller_class
  ingress_azurerm_dns_zone = var.ingress_azurerm_dns_zone

  customer_ns = module.c_customer_app.customer_ns

}



