#!/bin/bash
set -euo pipefail

dqt='"'

###########################################################################
#### Create service principal and save to $HOME/rbac.json
###########################################################################

. exports-private.sh

# Generate Azure client id and secret.
export RBAC_JSON="$HOME/rbac.json"

if test -f "$RBAC_JSON"; then
	RBAC="$(cat $RBAC_JSON)"
else
    RBAC_NAME="--name $AZURE_SERVICE_PRINCIPAL"
    RBAC_ROLE="--role 'Contributor'"
    RBAC_SCOPES="--scopes /subscriptions/${AZURE_SUBSCRIPTION_ID}"
	RBAC="$(az ad sp create-for-rbac $RBAC_NAME $RBAC_ROLE $RBAC_SCOPES)"
	echo $RBAC > $RBAC_JSON
fi

echo $RBAC 

###########################################################################
#### Read variables from RBAC dict
###########################################################################

function rdict {
	python3 -c "print($1[${dqt}$2${dqt}])"
}

ARM_TENANT_ID=$(rdict     "$RBAC" "tenant")
ARM_CLIENT_ID=$(rdict     "$RBAC" "appId")
ARM_CLIENT_SECRET=$(rdict "$RBAC" "password")

###########################################################################
#### Populate terraform variables file
###########################################################################

TFVARS="terraform.tfvars"

echo "
client_id                = ${dqt}${ARM_CLIENT_ID}${dqt}
client_secret            = ${dqt}${ARM_CLIENT_SECRET}${dqt}
location                 = ${dqt}${AZURE_LOCATION}${dqt}
resource_group_name      = ${dqt}${AZURE_RESOURCE_GROUP}${dqt}
dns_prefix               = ${dqt}${AZURE_AKS_DNS_PREFIX}${dqt}
admin_username           = ${dqt}${AZURE_ASK_NODES_ADMIN}${dqt}
cluster_name             = ${dqt}${AZURE_AKS_CLUSTER}${dqt}
ingress_azurerm_dns_zone = ${dqt}${CUSTOM_DOMAIN}${dqt}
email                    = ${dqt}${LETSENCRYPT_EMAIL}${dqt}
" > $TFVARS
cat $TFVARS

###########################################################################
#### Create AKS cluster
###########################################################################

TARGETS="\
 -target azurerm_resource_group.k8s \
 -target azurerm_kubernetes_cluster.k8s \
 -target tls_private_key.k8s-key \
 -target null_resource.k8s-save-key
"

echo "TARGETS: "
echo $TARGETS

terraform init $TARGETS
terraform plan  $TARGETS
terraform apply -auto-approve  $TARGETS

# ###########################################################################
# #### Configure AKS connection in local env 
# ###########################################################################

terraform output configure
terraform output -raw kube_config > ~/.kube/aksconfig
export KUBECONFIG=~/.kube/aksconfig
kubectl get nodes

# ###########################################################################
# #### Connect to AKS
# ###########################################################################

az account set --subscription $AZURE_SUBSCRIPTION_ID
az aks get-credentials \
	--resource-group $(terraform output -raw resource_group_name) \
	--name $(terraform output -raw kubernetes_cluster_name)

