#!/bin/bash

# required parameters in ENV:
# AZURE_SP_NAME
# AZURE_SP_TENANT
# AZURE_SP_PASSWORD
# AZURE_RESOURCE_GROUP
# AKS_CLUSTER_NAME
# AKS_SECRET_NAME
# AKS_SECRET_FILE_NAME
# AKS_SECRET_FILE_VALUE

# login
az login --service-principal -u $AZURE_SP_NAME -p $AZURE_SP_PASSWORD --tenant $AZURE_SP_TENANT > /dev/null

echo 'Fetching AKS credentials'
az aks get-credentials --resource-group $AZURE_RESOURCE_GROUP --name $AKS_CLUSTER_NAME
    
echo "Creating secret: $AKS_SECRET_NAME"
mkdir -p /tmp/aks
echo $AKS_SECRET_FILE_VALUE > /tmp/aks/$AKS_SECRET_FILE_NAME
kubectl create secret generic $AKS_SECRET_NAME --from-file=/tmp/aks/$AKS_SECRET_FILE_NAME
