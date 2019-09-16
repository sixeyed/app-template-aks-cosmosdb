#!/bin/bash

# required parameters in ENV:
# AZURE_SP_NAME
# AZURE_SP_TENANT
# AZURE_SP_PASSWORD
# AZURE_RESOURCE_GROUP
# AZURE_REGION
# COSMOSDB_ACCOUNT_NAME

# login
az login --service-principal -u $AZURE_SP_NAME -p $AZURE_SP_PASSWORD --tenant $AZURE_SP_TENANT > /dev/null

# create RG if needed:
az group show --name $AZURE_RESOURCE_GROUP > /dev/null
if [ $? != 0 ]; then
	echo "Creating new resource group: $AZURE_RESOURCE_GROUP"
	az group create --name $AZURE_RESOURCE_GROUP --location $AZURE_REGION > /dev/null
else
	echo "Using existing resource group: $AZURE_RESOURCE_GROUP"
fi

echo "Creating CosmosDB Account: $AZURE_RESOURCE_GROUP"
az cosmosdb create \
    --resource-group $AZURE_RESOURCE_GROUP \
    --name $COSMOSDB_ACCOUNT_NAME \
    --kind MongoDB