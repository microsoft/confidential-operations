// Copyright (c) Microsoft. All rights reserved.

param name string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: name
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/8'
      ]
    }
    subnets: [
      {
        name: '${name}-subnet'
        properties: {
          addressPrefix: '10.240.0.0/16'
        }
      }
    ]
  }
}
