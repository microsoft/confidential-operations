// Copyright (c) Microsoft. All rights reserved.

param name string
param k8sVersion string
param publicKeys array
param adminIds array
param vmSize string
param subnetId string
param registryName string
param linuxUser string = 'azureuser'
param nodeRGName string = resourceGroup().name

var roles = {
  networkContributor: subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '4d97b98b-1d4f-4787-a291-c67834d212e7'
  )
  acrPull: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')
}

resource registry 'Microsoft.ContainerRegistry/registries@2021-12-01-preview' existing = {
  name: registryName
}

resource aksUserManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: '${name}-user'
  location: resourceGroup().location
}

resource aksUserRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(name, deployment().name, roles.networkContributor)
  scope: resourceGroup()
  properties: {
    roleDefinitionId: roles.networkContributor
    principalId: aksUserManagedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

resource aksCluster 'Microsoft.ContainerService/managedClusters@2024-02-01' = {
  name: name
  location: resourceGroup().location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${aksUserManagedIdentity.id}': {}
    }
  }
  sku: {
    name: 'Base'
    tier: 'Standard'
  }
  properties: {
    dnsPrefix: name
    kubernetesVersion: k8sVersion
    nodeResourceGroup: nodeRGName
    linuxProfile: {
      adminUsername: linuxUser
      ssh: {
        publicKeys: publicKeys
      }
    }
    disableLocalAccounts: true
    networkProfile: {
      networkPlugin: 'azure'
      serviceCidr: '192.168.0.0/16' // CIDR notation chosen to not overlap vnet address range
      dnsServiceIP: '192.168.0.10'
      loadBalancerSku: 'standard'
      loadBalancerProfile: {
        managedOutboundIPs: {
          count: 1 // each IP has 64k available ports
        }
        allocatedOutboundPorts: 0 // 0 means automatic ports allocation
        idleTimeoutInMinutes: 4
      }
    }
    aadProfile: {
      adminGroupObjectIDs: adminIds
      enableAzureRBAC: true
      managed: true
    }
    agentPoolProfiles: [
      {
        name: 'systempool'
        count: 1
        mode: 'System'
        vmSize: vmSize
        enableAutoScaling: true
        minCount: 1
        maxCount: 20
        availabilityZones: [
          '1'
          '2'
          '3'
        ]
        osSKU: 'AzureLinux'
        maxPods: 250
        vnetSubnetID: subnetId
        nodeLabels: {
          mode: 'System'
        }
        osDiskType: 'Ephemeral'
        tags: {
          mode: 'system'
        }
        type: 'VirtualMachineScaleSets'
      }
    ]
    autoScalerProfile: {
      'skip-nodes-with-system-pods': 'true'
    }
    securityProfile: {
      imageCleaner: {
        enabled: true
        intervalHours: 24
      }
    }
  }
}

resource assignAcrPullToAks 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(resourceGroup().id, registryName, deployment().name, 'assignAcrPullToAks')
  scope: registry
  properties: {
    description: 'Assign Role to ACR'
    principalId: aksCluster.properties.identityProfile.kubeletidentity.objectId
    principalType: 'ServicePrincipal'
    roleDefinitionId: roles.acrPull
  }
}
