#!/bin/bash

# required parameters in ENV:
# AZURE_SP_NAME
# AZURE_SP_TENANT
# AZURE_SP_PASSWORD
# AZURE_RESOURCE_GROUP
# COSMOSDB_ACCOUNT_NAME

# login
az login --service-principal -u $AZURE_SP_NAME -p $AZURE_SP_PASSWORD --tenant $AZURE_SP_TENANT > /dev/null

echo "Fetching primary connection string for CosmosDB Account: $COSMOSDB_ACCOUNT_NAME"
connectionString=$(az cosmosdb list-connection-strings \
                        --name $COSMOSDB_ACCOUNT_NAME \
                        --resource-group $AZURE_RESOURCE_GROUP \
                        --query connectionStrings[0].connectionString \
                        -o tsv)

echo ::set-output name=connectionString::$connectionString