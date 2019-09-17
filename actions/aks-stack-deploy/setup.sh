#!/bin/bash

# required parameters in ENV:
# AZURE_SP_NAME
# AZURE_SP_TENANT
# AZURE_SP_PASSWORD
# AZURE_RESOURCE_GROUP
# AKS_CLUSTER_NAME
# DOCKER_COMPOSE_PATH
# DOCKER_STACK_NAME

# login
az login --service-principal -u $AZURE_SP_NAME -p $AZURE_SP_PASSWORD --tenant $AZURE_SP_TENANT > /dev/null

echo 'Fetching AKS credentials'
az aks get-credentials --resource-group $AZURE_RESOURCE_GROUP --name $AKS_CLUSTER_NAME
    
echo 'Deploying stack'
docker stack deploy --orchestrator=kubernetes -c $DOCKER_COMPOSE_PATH $DOCKER_STACK_NAME
