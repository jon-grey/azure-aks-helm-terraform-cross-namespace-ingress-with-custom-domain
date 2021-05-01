

# az aks create \
#     -n $AZURE_AKS_CLUSTER_NAME \
#     -g $AZURE_RESOURCE_GROUP \
#     -l $AZURE_LOCATION \
#     -c 2 \
#     --vm-set-type AvailabilitySet  \
#     --generate-ssh-keys \
#     --service-principal $ARM_CLIENT_ID \
#     --client-secret $ARM_CLIENT_SECRET



resource "azurerm_kubernetes_cluster" "k8s" {
  name                = var.cluster_name
  location            = var.location
  dns_prefix          = var.dns_prefix
  resource_group_name = var.azurerm_resource_group_k8s_name

  linux_profile {
    admin_username = var.admin_username

    ## SSH key is generated using "tls_private_key" resource
    ssh_key {
      key_data = "${trimspace(tls_private_key.aks-key.public_key_openssh)} ${var.admin_username}@azure.com"
    }
  }

  default_node_pool {
    os_disk_size_gb = 30
    node_count      = var.agent_count
    name            = "agentpool"
    vm_size         = "Standard_D2_v2"
    type            = "VirtualMachineScaleSets"
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  role_based_access_control {
    enabled = true
  }

  addon_profile {
    kube_dashboard {
      enabled = true
    }
  }

  network_profile {
    load_balancer_sku = "Standard"
    network_plugin = "kubenet"
  }

  tags = {
    environment = "Demo"
  }
}


## Private key for the kubernetes cluster ##
resource "tls_private_key" "k8s-key" {
  algorithm   = "RSA"
}

## Save the private key in the local workspace ##
resource "null_resource" "k8s-save-key" {
  triggers = {
    key = tls_private_key.aks-key.private_key_pem
  }

  provisioner "local-exec" {
    command = <<EOF
      mkdir -p ${path.root}/.ssh
      echo "${tls_private_key.aks-key.private_key_pem}" > ${path.root}/.ssh/id_rsa
      chmod 0600 ${path.root}/.ssh/id_rsa
EOF
  }
}