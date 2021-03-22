#!/usr/bin/bash

. ~/W/exports-private.sh

# Generate Azure client id and secret.
export RBAC_JSON="$HOME/W/rbac.json"

if test -f "$RBAC_JSON"; then
	export RBAC="$(cat $RBAC_JSON)"
else
	RBAC="$(az ad sp create-for-rbac --role='Contributor' --scopes=/subscriptions/${SUBSCRIPTION_ID})"
	echo $RBAC > $RBAC_JSON
fi

echo $RBAC 

function rdict {
	python3 -c "print($1[\"$2\"])"
}


export ARM_SUBSCRIPTION_ID="$SUBSCRIPTION_ID"
export ARM_TENANT_ID=$(rdict "$RBAC" "tenant")
export ARM_CLIENT_ID=$(rdict "$RBAC" "appId")
export ARM_CLIENT_SECRET=$(rdict "$RBAC" "password")


echo "ARM_TENANT_ID=$ARM_TENANT_ID"
echo "ARM_CLIENT_ID=$ARM_CLIENT_ID"

TFVARS="terraform.tfvars"

dqt='"'

rm $TFVARS -Rf
touch $TFVARS
echo "client_id     = ${dqt}${ARM_CLIENT_ID}${dqt}" >> $TFVARS
echo "client_secret = ${dqt}${ARM_CLIENT_SECRET}${dqt}" >> $TFVARS
cat $TFVARS

terraform init
terraform plan
terraform apply -auto-approve
terraform output configure
terraform output -raw kube_config > ~/.kube/aksconfig
export KUBECONFIG=~/.kube/aksconfig
kubectl get nodes


az account set --subscription $SUBSCRIPTION_ID
az aks get-credentials --resource-group $(terraform output -raw resource_group_name) --name $(terraform output -raw kubernetes_cluster_name)























