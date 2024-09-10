// Copyright (c) Microsoft. All rights reserved.

param name string
param cpUserId string

resource CPKeyVault 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {
  name: name
  location: resourceGroup().location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
    enablePurgeProtection: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 45
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: cpUserId
        permissions: {
          secrets: [
            'get'
            'list'
          ]
          keys: [
            'get'
            'list'
          ]
          certificates: [
            'get'
            'list'
          ]
        }
      }
    ]
  }
}

resource keyVaultNameAdd 'Microsoft.KeyVault/vaults/accessPolicies@2021-11-01-preview' = {
  name: 'add'
  parent: CPKeyVault
  properties: {
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: cpUserId
        permissions: {
          keys: [
            'get'
            'list'
          ]
          secrets: [
            'get'
            'list'
          ]
          certificates: [
            'get'
            'list'
            'import'
          ]
        }
      }
    ]
  }
}
