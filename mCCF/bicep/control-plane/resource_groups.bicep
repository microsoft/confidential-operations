// Copyright (c) Microsoft. All rights reserved.

targetScope = 'subscription'

param name string
param location string

resource controlPlaneRG 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: name
  location: location
}
