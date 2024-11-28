targetScope = 'subscription'

/* Parameter definition -------------*/
// Global
param par_customerShort string
param par_environment string

// Static
param PAR_SERVICENAMEOAI string = 'oai'
param PAR_SERVICENAMEASP string = 'asp'
param PAR_SERVICENAMEAPP string = 'app'

// Dynamic
param par_rgName string = '${par_customerShort}-rgr-${PAR_SERVICENAMEOAI}-${par_environment}-${par_location}-001'
param par_location string = 'westeurope'
param par_cognitiveServicesName string = '${par_customerShort}-${PAR_SERVICENAMEOAI}-${par_environment}-${par_location}-001'
param par_skuName string = 'S0'
param par_kind string = 'OpenAI'
param par_publicNetworkAccess string = 'Enabled'
param par_cognitiveServicesDeploymentName string = 'gpt-4o'
param par_skuDeploymentName string = 'GlobalStandard'
param par_skuDeploymentCapacity int = 50
param par_modelVersion string = '2024-08-06'
param par_raiPolicyName string = 'Microsoft.DefaultV2'
param par_versionUpgradeOption string = 'OnceCurrentVersionExpired'
param par_appServicePlanName string = '${par_customerShort}-${PAR_SERVICENAMEASP}-${par_environment}-${par_location}-001'
param par_appServiceName string = '${par_customerShort}-${PAR_SERVICENAMEAPP}-${par_environment}-${par_location}-001'
param par_runtimeName string = 'python'
param par_runtimeVersion string = '3.11'
param par_azureOpenAIEndpoint string = 'https://${par_cognitiveServicesName}.openai.azure.com/'
param par_azureOpenAIKey string = ''

/*  ------------ Parameter definition*/

/* Resources ------------------------*/
// Resource group -------------------------------------------------------
resource rgName 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: par_rgName
  location: par_location
}
//----------------------------------------------------------------------

// Azure OpenAI --------------------------------------------------------
module cognitiveServicesAccounts 'module/cognitiveServicesAccounts.bicep' = {
  name: par_cognitiveServicesName
  scope: rgName
  params: {
    cognitiveServicesName: par_cognitiveServicesName
    location: par_location
    skuName: par_skuName
    kind: par_kind
    publicNetworkAccess: par_publicNetworkAccess
  }
}
//----------------------------------------------------------------------

// Azure OpenAI Model --------------------------------------------------
module cognitiveServicesAccountsDeployments 'module/cognitiveServicesAccountsDeployments.bicep' = {
  name: par_cognitiveServicesDeploymentName
  scope: rgName
  params: {
    cognitiveServicesName: cognitiveServicesAccounts.name
    cognitiveServicesDeploymentName: par_cognitiveServicesDeploymentName
    skuDeploymentCapacity: par_skuDeploymentCapacity
    skuDeploymentName: par_skuDeploymentName
    modelFormat: par_kind
    modelVersion: par_modelVersion
    raiPolicyName: par_raiPolicyName
    versionUpgradeOption: par_versionUpgradeOption
  }
}
//----------------------------------------------------------------------

// App Service Plan ----------------------------------------------------
module appServicePlan 'module/appServicePlan.bicep' = {
  name: par_appServicePlanName
  scope: rgName
  params: {
    appServicePlanName: par_appServicePlanName
  }
}
//-----------------------------------------------------------------------

// App Service ----------------------------------------------------------
module appService 'module/appService.bicep' = {
  name: par_appServiceName
  scope: rgName
  params: {
    appServiceName: par_appServiceName
    appServicePlanId: appServicePlan.outputs.id
    runtimeName: par_runtimeName
    runtimeVersion: par_runtimeVersion
    azureOpenAIEndpoint: par_azureOpenAIEndpoint
    azureOpenAIKey: par_azureOpenAIKey
    azureOpenAIResource: par_cognitiveServicesName
  }
}
//-----------------------------------------------------------------------

/*------------------------ Ressources*/
