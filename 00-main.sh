#!/bin/bash
set -euo pipefail

DQT='"'

###########################################################################
#### Create service principal and save to $HOME/rbac.json
###########################################################################

. exports-private.sh

az account set --subscription $AZURE_SUBSCRIPTION_ID
az aks get-credentials \
	--resource-group $AZURE_RESOURCE_GROUP \
	--name $AZURE_AKS_CLUSTER_NAME || true

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

export KUBECONFIG=~/.kube/aksconfig


echo $RBAC 

###########################################################################
#### Read variables from RBAC dict
###########################################################################

function rdict {
	python3 -c "print($1[${DQT}$2${DQT}])"
}

ARM_TENANT_ID=$(rdict     "$RBAC" "tenant")
ARM_CLIENT_ID=$(rdict     "$RBAC" "appId")
ARM_CLIENT_SECRET=$(rdict "$RBAC" "password")

###########################################################################
#### Populate terraform variables file
###########################################################################

TFVARS="terraform.tfvars"

echo "
client_id                = ${DQT}${ARM_CLIENT_ID}${DQT}
client_secret            = ${DQT}${ARM_CLIENT_SECRET}${DQT}
location                 = ${DQT}${AZURE_LOCATION}${DQT}
resource_group_name      = ${DQT}${AZURE_RESOURCE_GROUP}${DQT}
container_registry_name  = ${DQT}${AZURE_CONTAINER_REGISTRY}${DQT}
dns_prefix               = ${DQT}${AZURE_AKS_DNS_PREFIX}${DQT}
admin_username           = ${DQT}${AZURE_AKS_NODES_ADMIN}${DQT}
cluster_name             = ${DQT}${AZURE_AKS_CLUSTER_NAME}${DQT}
ingress_azurerm_dns_zone = ${DQT}${CUSTOM_DOMAIN}${DQT}
email                    = ${DQT}${LETSENCRYPT_EMAIL}${DQT}
" > $TFVARS
cat $TFVARS

###########################################################################
#### Create AKS cluster
###########################################################################

# TARGETS="\
#  -target module.a_aks_cluster \
#  -target module.a_az_container_registry \
# "

echo "TARGETS: "
#echo $TARGETS

echo "############# INIT: "
terraform init #$TARGETS
echo "############# PLAN: "
terraform plan  #$TARGETS
echo "############# APPLY: "
terraform apply -auto-approve  #$TARGETS

# ###########################################################################
# #### Configure AKS connection in local env 
# ###########################################################################
echo "############# OUT: "
terraform output configure
terraform output -raw kube_config > ~/.kube/aksconfig
export KUBECONFIG=~/.kube/aksconfig
kubectl get nodes

# ###########################################################################
# #### Connect to AKS
# ###########################################################################

az aks get-credentials \
	--resource-group $AZURE_RESOURCE_GROUP \
	--name $AZURE_AKS_CLUSTER_NAME || true