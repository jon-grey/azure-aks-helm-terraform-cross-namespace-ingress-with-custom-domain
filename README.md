# Step 0 - Setup Custom Domain Name

[Azure Kubernetes Service (AKS) connect servise to custom domain via ingress](https://alakbarv.azurewebsites.net/2019/01/25/azure-kubernetes-service-aks-connect-servise-to-custom-domain-via-ingress/)

[How to Verify Custom Domain from GoDaddy.com in Azure Portal?](https://jeanpaul.cloud/2020/04/01/how-to-verify-custom-domain-from-godaddy-com-in-azure-portal/)

[Tutorial: Map existing custom DNS name - Azure App Service](https://docs.microsoft.com/en-us/azure/app-service/app-service-web-tutorial-custom-domain)

[Add custom domain name to Azure Active Directory - Learn](https://docs.microsoft.com/en-us/learn/modules/add-custom-domain-name-azure-active-directory/)

[How to configure a root domain in an Azure Static Web App](https://burkeholland.github.io/posts/static-app-root-domain/)

[Setup a custom domain in Azure Static Web Apps](https://docs.microsoft.com/en-us/azure/static-web-apps/custom-domain)

[Custom domains in Azure Kubernetes Service (AKS) with NGINX Ingress and Azure DNS](https://thorsten-hans.com/custom-domains-in-azure-kubernetes-with-nginx-ingress-azure-cli)

# Step 1 - Provision AKS Cluster

```sh
bash setup-terraform.sh
```

# Step 2 - Validate and deploy cluster and demo app

```sh
terraform plan # validate
terraform apply # deploy
```