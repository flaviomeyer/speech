param cognitiveServicesName string
param location string
param skuName string
param kind string
param defaultAction string = 'Allow'
param publicNetworkAccess string

resource cognitiveServicesAccounts 'Microsoft.CognitiveServices/accounts@2024-06-01-preview' = {
  name: cognitiveServicesName
  location: location
  sku: {
    name: skuName
  }
  kind: kind
  properties: {
    customSubDomainName: cognitiveServicesName
    networkAcls: {
      defaultAction: defaultAction
    }
    publicNetworkAccess: publicNetworkAccess
  }
}
