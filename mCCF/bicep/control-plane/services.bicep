// Copyright (c) Microsoft. All rights reserved.

targetScope = 'resourceGroup' // Deploy with group specified in ./resource_group.bicep

module identities './identities.bicep' = {
  name: 'cpIdentities'
}
var AKSUserId = identities.outputs.managedIdentityIds[0]
var CPUserId = identities.outputs.managedIdentityIds[1]
var IDUserId = identities.outputs.managedIdentityIds[2]
var CapacityProcessorUserId = identities.outputs.managedIdentityIds[3]
var EV2UserId = identities.outputs.managedIdentityIds[4]

// Create a virtual network
// TODO: Explain what this is for
module virtualNetwork 'virtual_network.bicep' = {
  name: 'cpVirtualNetwork'
  params: {
    name: 'cpVirtualNetwork'
  }
}

// Create a keyvault
// TODO: Explain what this is for
module keyVault 'key_vault.bicep' = {
  name: 'cpKeyVault'
  params: {
    name: '${resourceGroup().name}-kv'
    cpUserId: CPUserId
  }
}

// Create a database for the control plane
// TODO: Explain what this is for
module database 'database.bicep' = {
  name: 'cpDatabase'
  params: {
    name: toLower('cpDatabase')
    cpUserId: CPUserId
    locations: [
      'westus' // We only have quota in westus
    ]
  }
}

// Create a storage account for the control place
// TODO: Explain what this is for
var storageAccountName = toLower(replace('storage${resourceGroup().name}', '-', ''))
module storageAccount './storage_account.bicep' = {
  name: 'cpStorageAccount'
  params: {
    name: storageAccountName
    cpUserId: CPUserId
  }
}
