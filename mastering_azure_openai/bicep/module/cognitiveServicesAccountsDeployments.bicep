param cognitiveServicesDeploymentName string
param cognitiveServicesName string
@minValue(1)
@maxValue(150)
param skuDeploymentCapacity int
@allowed([
  'Standard'
  'GlobalStandard'
])
param skuDeploymentName string
param modelFormat string
@allowed([
  '2024-05-13'
  '2024-08-06'
])
param modelVersion string
@allowed([
  'Microsoft.Default'
  'Microsoft.DefaultV2'
])
param raiPolicyName string
@allowed([
  'NoAutoUpgrade'
  'OnceCurrentVersionExpired'
  'OnceNewDefaultVersionAvailable'
])
param versionUpgradeOption string

resource cognitiveServicesAccount 'Microsoft.CognitiveServices/accounts@2024-06-01-preview' existing = {
  name: cognitiveServicesName
}

resource cognitiveServicesAccountsDeployments 'Microsoft.CognitiveServices/accounts/deployments@2024-06-01-preview' = {
  name: cognitiveServicesDeploymentName
  parent: cognitiveServicesAccount
  sku: {
    capacity: skuDeploymentCapacity
    name: skuDeploymentName
  }
  properties: {
    model: {
      format: modelFormat
      name: cognitiveServicesDeploymentName
      version: modelVersion
    }
    raiPolicyName: raiPolicyName
    versionUpgradeOption: versionUpgradeOption
  }
}
