#!/bin/bash
set -euo pipefail

dqt='"'

###########################################################################
#### Create service principal and save to $HOME/rbac.json
###########################################################################

. exports-private.sh

az account set --subscription $AZURE_SUBSCRIPTION_ID
az aks get-credentials \
	--resource-group $AZURE_RESOURCE_GROUP \
	--name $AZURE_AKS_CLUSTER || true

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
container_registry_name  = ${dqt}${AZURE_CONTAINER_REGISTRY}${dqt}
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
	--name $AZURE_AKS_CLUSTER || true