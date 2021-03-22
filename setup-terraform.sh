#!/usr/bin/bash -euo pipefail

###########################################################################
#### Create service principal and save to $HOME/rbac.json
###########################################################################

. exports-private.sh

# Generate Azure client id and secret.
export RBAC_JSON="$HOME/rbac.json"

if test -f "$RBAC_JSON"; then
	export RBAC="$(cat $RBAC_JSON)"
else
	RBAC=$(az ad sp create-for-rbac \
               --name $AZURE_SERVICE_PRINCIPAL \
               --role 'Contributor' \
               --scopes /subscriptions/${AZURE_SUBSCRIPTION_ID}
          )
	echo $RBAC > $RBAC_JSON
fi

echo $RBAC 

###########################################################################
#### Export
###########################################################################

function rdict {
	python3 -c "print($1[\"$2\"])"
}

export ARM_TENANT_ID=$(rdict "$RBAC" "tenant")
export ARM_CLIENT_ID=$(rdict "$RBAC" "appId")
export ARM_CLIENT_SECRET=$(rdict "$RBAC" "password")

###########################################################################
####
###########################################################################

TFVARS="terraform.tfvars"

dqt='"'

rm $TFVARS -Rf
touch $TFVARS
echo "client_id            = ${dqt}${ARM_CLIENT_ID}${dqt}"        >> $TFVARS
echo "client_secret        = ${dqt}${ARM_CLIENT_SECRET}${dqt}"    >> $TFVARS
echo "location             = ${dqt}${AZURE_LOCATION}${dqt}"       >> $TFVARS
echo "resource_group_name  = ${dqt}${AZURE_RESOURCE_GROUP}${dqt}" >> $TFVARS
echo "cluster_name         = ${dqt}${AZURE_AKS_CLUSTER}${dqt}"    >> $TFVARS
cat $TFVARS

###########################################################################
####
###########################################################################

terraform init -target=
terraform plan
terraform apply -auto-approve
terraform output configure
terraform output -raw kube_config > ~/.kube/aksconfig
export KUBECONFIG=~/.kube/aksconfig
kubectl get nodes

###########################################################################
####
###########################################################################


az account set --subscription $AZURE_SUBSCRIPTION_ID
az aks get-credentials \
	--resource-group $(terraform output -raw resource_group_name) \
	--name $(terraform output -raw kubernetes_cluster_name)

