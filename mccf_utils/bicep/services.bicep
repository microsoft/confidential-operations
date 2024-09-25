// Copyright (c) Microsoft. All rights reserved.

targetScope = 'subscription'

param RESOURCE_GROUP_NAME string
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: RESOURCE_GROUP_NAME
  location: deployment().location
}

param DP_PRIMARY_COSMOS_ACCOUNT_NAME string
param DATAPLANE_DNS_NAME string
param MAIN_DATAPLANE_ACR string
param ACCL_SHARED_KV string
module prerequisites '../acc_ledger/Ev2Files/accl-dataplane/Bicep/dp-prerequisites.bicep' = {
  name: 'prerequisites'
  scope: resourceGroup
  params: {
    DATAPLANE_COMMON_RG: resourceGroup.name
    DATAPLANE_COMMON_RG_LOCATION: deployment().location
    DP_PRIMARY_COSMOS_ACCOUNT_NAME: DP_PRIMARY_COSMOS_ACCOUNT_NAME
    DATAPLANE_DNS_NAME: DATAPLANE_DNS_NAME
    MAIN_DATAPLANE_ACR: MAIN_DATAPLANE_ACR
    ACCL_SHARED_KV: ACCL_SHARED_KV
  }
}

@description('Custom suffix to be applied to new resources. E.g. weu-1c')
param LOCATION_SHORT_NAME string
@allowed(['prod', 'ppe', 'staging'])
param ENVIRONMENT string
param SYSTEM_POOL_VM_SIZE string
param USER_POOL_VM_SIZE string
param USER_POOL_INSTANCES int
param SYSTEM_POOL_INSTANCES int
param SYSTEM_POOL_NODE_COUNT int
param SYSTEM_POOL_AVAILABILITY_ZONES array
param USER_POOL_AVAILABILITY_ZONES array
param USER_POOL_NODE_COUNT int
param ADMIN_USERNAME string
param GOV_KV_NAME string
param DS_KV_NAME string
param CCF_KV_NAME string
param OFFLINE_BACKUP_STORAGE_NAME string
param DEPLOYMENT_SCRIPT_STORAGE_NAME string
param CCFMGMT_STORAGE_NAME string
param CCF_UAMI_NAME string
param EV2_UAMI_NAME string
param K8S_VERSION string
module buildout '../acc_ledger/Ev2Files/accl-dataplane/Bicep/dp-buildout.bicep' = {
  name: 'buildout'
  scope: resourceGroup
  dependsOn: [
    prerequisites
  ]
  params: {
    DP_PRIMARY_COSMOS_ACCOUNT_NAME: DP_PRIMARY_COSMOS_ACCOUNT_NAME
    DP_PRIMARY_COSMOS_DB_RESOURCEGROUP_NAME: resourceGroup.name
    MAIN_DATAPLANE_ACR: MAIN_DATAPLANE_ACR
    CONTROLPLANE_RG: resourceGroup.name
    LOCATION: deployment().location
    LOCATION_SHORT_NAME: LOCATION_SHORT_NAME
    ENVIRONMENT: ENVIRONMENT
    SYSTEM_POOL_VM_SIZE: SYSTEM_POOL_VM_SIZE
    USER_POOL_VM_SIZE: USER_POOL_VM_SIZE
    USER_POOL_INSTANCES: USER_POOL_INSTANCES
    SYSTEM_POOL_INSTANCES: SYSTEM_POOL_INSTANCES
    SYSTEM_POOL_NODE_COUNT: SYSTEM_POOL_NODE_COUNT
    SYSTEM_POOL_AVAILABILITY_ZONES: SYSTEM_POOL_AVAILABILITY_ZONES
    USER_POOL_AVAILABILITY_ZONES: USER_POOL_AVAILABILITY_ZONES
    USER_POOL_NODE_COUNT: USER_POOL_NODE_COUNT
    ADMIN_USERNAME: ADMIN_USERNAME
    GOV_KV_NAME: GOV_KV_NAME
    DS_KV_NAME: DS_KV_NAME
    CCF_KV_NAME: CCF_KV_NAME
    OFFLINE_BACKUP_STORAGE_NAME: OFFLINE_BACKUP_STORAGE_NAME
    DEPLOYMENT_SCRIPT_STORAGE_NAME: DEPLOYMENT_SCRIPT_STORAGE_NAME
    CCFMGMT_STORAGE_NAME: CCFMGMT_STORAGE_NAME
    CCF_UAMI_NAME: CCF_UAMI_NAME
    EV2_UAMI_NAME: EV2_UAMI_NAME
    DATAPLANE_DNS_NAME: DATAPLANE_DNS_NAME
    K8S_VERSION: K8S_VERSION
    MAIN_SUBSCRIPTION: subscription().subscriptionId
    IsNewRegion: true
  }
}
