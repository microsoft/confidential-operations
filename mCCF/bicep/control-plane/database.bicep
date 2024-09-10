// Copyright (c) Microsoft. All rights reserved.

param name string
param locations array = [resourceGroup().location]
param cpUserId string

// TODO: Give this a descriptive name
var sqlRole = '00000000-0000-0000-0000-000000000002'

resource cosmosdb_account 'Microsoft.DocumentDB/databaseAccounts@2024-05-15' = {
  name: name
  location: locations[0]
  kind: 'GlobalDocumentDB'
  properties: {
    locations: [
      for (location, locationIdx) in locations: {
        locationName: location
        failoverPriority: locationIdx
        isZoneRedundant: false
      }
    ]
    databaseAccountOfferType: 'Standard'
    disableLocalAuth: true
  }
}

resource cosmosdb_database 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2024-05-15' = {
  parent: cosmosdb_account
  name: 'ACCL-ControlPlane'
  properties: {
    options: {}
    resource: {
      id: 'ACCL-ControlPlane' // used in the code - static
    }
  }
}

resource cpSqlRoleAssignment 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2024-05-15' = {
  name: guid(name, cpUserId, deployment().name, sqlRole)
  properties: {
    roleDefinitionId: sqlRole
    scope: cosmosdb_account.id
    principalId: cpUserId
  }
  dependsOn: [
    cosmosdb_database
  ]
}
