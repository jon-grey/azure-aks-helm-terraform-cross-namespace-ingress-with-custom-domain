# Step 0 - Setup Custom Domain Name in Azure Portal

[Azure Kubernetes Service (AKS) connect servise to custom domain via ingress](https://alakbarv.azurewebsites.net/2019/01/25/azure-kubernetes-service-aks-connect-servise-to-custom-domain-via-ingress/)

[How to Verify Custom Domain from GoDaddy.com in Azure Portal?](https://jeanpaul.cloud/2020/04/01/how-to-verify-custom-domain-from-godaddy-com-in-azure-portal/)

[Tutorial: Map existing custom DNS name - Azure App Service](https://docs.microsoft.com/en-us/azure/app-service/app-service-web-tutorial-custom-domain)

[Add custom domain name to Azure Active Directory - Learn](https://docs.microsoft.com/en-us/learn/modules/add-custom-domain-name-azure-active-directory/)

[How to configure a root domain in an Azure Static Web App](https://burkeholland.github.io/posts/static-app-root-domain/)

[Setup a custom domain in Azure Static Web Apps](https://docs.microsoft.com/en-us/azure/static-web-apps/custom-domain)

[Custom domains in Azure Kubernetes Service (AKS) with NGINX Ingress and Azure DNS](https://thorsten-hans.com/custom-domains-in-azure-kubernetes-with-nginx-ingress-azure-cli)

## Step 0.1 - Populate exports-private.sh

```sh
export AZURE_SUBSCRIPTION_ID="" # find in azure portal
export AZURE_RESOURCE_GROUP=aks-resource-group-demo
export AZURE_CONTAINER_REGISTRY="" #[a-z0-9]
export AZURE_AKS_CLUSTER=aks-cluster-demo-000
export AZURE_AKS_DNS_PREFIX=aks-dns-demo-000
export AZURE_SERVICE_PRINCIPAL=azure-cli-2021-03-21-19-00-00
export AZURE_LOCATION="germanywestcentral"
export CUSTOM_DOMAIN="example.com"
export LETSENCRYPT_EMAIL="example@gmail.com"
export AZURE_ASK_NODES_ADMIN="demo"

```

# Prod Steps

TODO

# Dev Steps

For local development first do

```sh
. exports-private.sh
az login
az account set --subscription $AZURE_SUBSCRIPTION_ID
az aks get-credentials --resource-group $AZURE_RESOURCE_GROUP --name $AZURE_AKS_CLUSTER
az acr login -n $AZURE_CONTAINER_REGISTRY.azurecr.io

# example build and push images to registry
docker build -t $AZURE_CONTAINER_REGISTRY.azurecr.io/angular-news:dev .
docker push $AZURE_CONTAINER_REGISTRY.azurecr.io/angular-news:dev
```

## Step A - Provision AKS Cluster with Cointainer Registry

```sh
bash A00-terraform-setup-aks-cluster.sh
```

## Step B - Provision Nginx Ingress

```sh
bash B00-terraform-setup-ingress-nginx.sh
```

## Step C - Provision Customer App

```sh
bash C00-terraform-setup-customer-app.sh
```
