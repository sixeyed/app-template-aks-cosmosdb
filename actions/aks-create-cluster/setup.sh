#!/bin/bash

# required parameters in ENV:
# AZURE_SP_NAME
# AZURE_SP_TENANT
# AZURE_SP_PASSWORD
# AZURE_SP_APP_ID
# AZURE_RESOURCE_GROUP
# AZURE_REGION
# AKS_CLUSTER_NAME
# AKS_NODE_COUNT

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

echo "Creating AKS cluster: $AKS_CLUSTER_NAME"
az aks create \
    --resource-group $AZURE_RESOURCE_GROUP \
    --name $AKS_CLUSTER_NAME \
    --node-count $AKS_NODE_COUNT \
    --enable-addons monitoring \
    --generate-ssh-keys \
    --service-principal $AZURE_SP_APP_ID \
    --client-secret $AZURE_SP_PASSWORD

# get creds for Kubectl
az aks get-credentials --resource-group $AZURE_RESOURCE_GROUP --name $AKS_CLUSTER_NAME
    
echo 'Initializing Helm'
kubectl -n kube-system create serviceaccount tiller
kubectl -n kube-system create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount kube-system:tiller
helm init --service-account tiller --wait

echo 'Deploying etcd for Compose on Kubernetes'
kubectl create namespace compose
helm install --name etcd-operator stable/etcd-operator --namespace compose --wait
kubectl apply -f /compose-etcd.yaml

echo 'Installing Compose on Kubernetes'
installer-linux -namespace=compose -etcd-servers=http://compose-etcd-client:2379 -tag="v0.4.23"
