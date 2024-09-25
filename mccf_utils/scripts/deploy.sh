#!/bin/bash

SCRIPT_DIR=$(dirname "$0")

$SCRIPT_DIR/fetch.sh # Sources the env so no need to here

# If there is a $PREFIX value in the parameters, allow user to set it
$SCRIPT_DIR/set_deployment_name.sh

# Modify the bicep templates to suit our use case
$SCRIPT_DIR/patches_apply.sh

# Get the deployment info
SUBSCRIPTION=$(az account show --query 'name' -o tsv)
RESOURCE_GROUP=$(grep -oP "(?<=param RESOURCE_GROUP_NAME = ')[^']+" "$SCRIPT_DIR/../bicep/services.bicepparam")
echo "Subscription: $SUBSCRIPTION"
echo "Resource Group: $RESOURCE_GROUP"

read -p "Please enter the deployment name: " DEP_NAME
read -p "Please enter the location to deploy to: " LOCATION

az deployment sub create -c \
    -n $DEP_NAME \
    -l $LOCATION \
    --template-file $SCRIPT_DIR/../bicep/services.bicep \
    --parameters $SCRIPT_DIR/../bicep/services.bicepparam

