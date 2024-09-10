// Copyright (c) Microsoft. All rights reserved.

var identities = [
  'AKSUser'
  'CPUser'
  'IDUser'
  'CapacityProcessorUser'
  'EV2User'
]

resource managedIdentities 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = [
  for identityName in identities: {
    name: identityName
    location: resourceGroup().location
  }
]

output managedIdentityIds array = [for (identity, i) in identities: managedIdentities[i].properties.principalId]
