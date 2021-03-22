#!/usr/bin/bash

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

export ARM_SUBSCRIPTION_ID="$AZURE_SUBSCRIPTION_ID"
export ARM_TENANT_ID=$(rdict "$RBAC" "tenant")
export ARM_CLIENT_ID=
export ARM_CLIENT_SECRET=$(rdict "$RBAC" "password")

###########################################################################
####
###########################################################################

TFVARS="terraform.tfvars"

dqt='"'

rm $TFVARS -Rf
touch $TFVARS
echo "client_id     = ${dqt}$(rdict "$RBAC" "appId")${dqt}" >> $TFVARS
echo "client_secret = ${dqt}${ARM_CLIENT_SECRET}${dqt}" >> $TFVARS
echo "location = ${dqt}${ARM_CLIENT_SECRET}${dqt}" >> $TFVARS
echo "resource_group_name = ${dqt}${ARM_CLIENT_SECRET}${dqt}" >> $TFVARS
echo "cluster_name = ${dqt}${ARM_CLIENT_SECRET}${dqt}" >> $TFVARS
cat $TFVARS

###########################################################################
####
###########################################################################

terraform init
terraform plan
terraform apply -auto-approve
terraform output configure
terraform output -raw kube_config > ~/.kube/aksconfig
export KUBECONFIG=~/.kube/aksconfig
kubectl get nodes

###########################################################################
####
###########################################################################


az account set --subscription $SUBSCRIPTION_ID
az aks get-credentials \
	--resource-group $(terraform output -raw resource_group_name) \
	--name $(terraform output -raw kubernetes_cluster_name)

