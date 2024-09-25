using './services.bicep'

param RESOURCE_GROUP_NAME = 'domayremccf11'

// Prerequisites
param DP_PRIMARY_COSMOS_ACCOUNT_NAME = 'domayremccf11dbacc'
param DATAPLANE_DNS_NAME = 'domayremccf11dns.core.azure.com'
param MAIN_DATAPLANE_ACR = 'domayremccf11acr'
param ACCL_SHARED_KV = 'domayremccf11kv'

// Buildout
param LOCATION_SHORT_NAME = 'weu'
param ENVIRONMENT = 'staging'
param SYSTEM_POOL_VM_SIZE = 'standard_d8s_v3'
param USER_POOL_VM_SIZE = 'standard_dc8s_v3`'
param USER_POOL_INSTANCES = 1
param SYSTEM_POOL_INSTANCES = 1
param SYSTEM_POOL_NODE_COUNT = 1
param SYSTEM_POOL_AVAILABILITY_ZONES = ['1', '2', '3']
param USER_POOL_AVAILABILITY_ZONES = ['1', '2', '3']
param USER_POOL_NODE_COUNT = 1
param ADMIN_USERNAME = 'admin-user'
param GOV_KV_NAME = 'domayremccf11govkv'
param DS_KV_NAME = 'domayremccf11dskv'
param CCF_KV_NAME = 'domayremccf11ccfkv'
param OFFLINE_BACKUP_STORAGE_NAME = 'domayremccf11offlbackup'
param DEPLOYMENT_SCRIPT_STORAGE_NAME = 'domayremccf11depscript'
param CCFMGMT_STORAGE_NAME = 'domayremccf11ccfmgmt'
param CCF_UAMI_NAME = 'domayremccf11ccfuami'
param EV2_UAMI_NAME = 'domayremccf11ev2uami'
param K8S_VERSION = '1.28.3'
