# app-template-aks-cosmosdb

Docker Application Template for deploying a CosmosDB-powered app onto Azure Kubernetes Service.

## Pre-requisites

1. You need a version of [Docker Desktop](https://www.docker.com/products/docker-desktop) with [Application Templates](https://blog.docker.com/2019/07/application-templates-docker-desktop-enterprise/) enabled.

> The demo is a Linux app, so on Windows you need to use Linux container mode

2. Create a Service Principal in Azure. You can use the [Azure CLI](https://github.com/Azure/azure-cli):

```
az ad sp create-for-rbac --name http://app-template 
```

3. Your GitHub account needs to be approved for [GitHub Actions](https://help.github.com/en/articles/about-github-actions) (currently in beta). Then create an empty repo and set the following secrets (under _Settings...Secrets_):

- `AZURE_SP_APP_ID` - Service Principal application ID
- `AZURE_SP_NAME` - Service Principal name
- `AZURE_SP_PASSWORD` - Service Principal password
- `AZURE_SP_TENANT` - Service Principal tenant
- `DOCKER_HUB_USERNAME` - Docker Hub username
- `DOCKER_HUB_PASSWORD` - Docker Hub password