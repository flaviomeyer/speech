param appServiceName string
param location string = resourceGroup().location
param appServicePlanId string

// Runtime Properties
@allowed([
  'dotnet'
  'dotnetcore'
  'dotnet-isolated'
  'node'
  'python'
  'java'
  'powershell'
  'custom'
])
param runtimeName string
param runtimeNameAndVersion string = '${runtimeName}|${runtimeVersion}'
param runtimeVersion string
param linuxFxVersion string = runtimeNameAndVersion

// Microsoft.Web/sites Properties
param kind string = 'app,linux'

// Microsoft.Web/sites/config
param alwaysOn bool = true
param ftpsState string = 'FtpsOnly'
param appCommandLine string = 'python3 -m gunicorn app:app'
param numberOfWorkers int = -1
param minimumElasticInstanceCount int = -1
param use32BitWorkerProcess bool = false
param functionAppScaleLimit int = -1
param healthCheckPath string = ''
param allowedOrigins array = []
param clientAffinityEnabled bool = true
param azureOpenAIEndpoint string
param azureOpenAIKey string
param azureOpenAIResource string

resource appService 'Microsoft.Web/sites@2024-04-01' = {
  name: appServiceName
  location: location
  kind: kind
  properties: {
    serverFarmId: appServicePlanId
    siteConfig: {
      appSettings: [
        {
          name: 'AZURE_OPENAI_ENDPOINT'
          value: azureOpenAIEndpoint
        }
        {
          name: 'AZURE_OPENAI_MAX_TOKENS'
          value: '800'
        }
        {
          name: 'AZURE_OPENAI_KEY'
          value: azureOpenAIKey
        }
        {
          name: 'AZURE_OPENAI_MODEL'
          value: 'gpt-4o'
        }
        {
          name: 'AZURE_OPENAI_MODEL_NAME'
          value: 'gpt-4o'
        }
        {
          name: 'AZURE_OPENAI_RESOURCE'
          value: azureOpenAIResource
        }
        {
          name: 'AZURE_OPENAI_SYSTEM_MESSAGE'
          value: 'You are an AI assistant that helps people find information.'
        }
        {
          name: 'AZURE_OPENAI_TEMPERATURE'
          value: '0.7'
        }
        {
          name: 'AZURE_OPENAI_TOP_P'
          value: '0.95'
        }
        {
          name: 'AZURE_SEARCH_ENABLE_IN_DOMAIN'
          value: 'false'
        }
        {
          name: 'AZURE_SEARCH_STRICTNESS'
          value: '3'
        }
        {
          name: 'AZURE_SEARCH_TOP_K'
          value: '5'
        }
        {
          name: 'AZURE_SEARCH_USE_SEMANTIC_SEARCH'
          value: 'false'
        }
        {
          name: 'DATASOURCE_TYPE'
          value: 'AzureCognitiveSearch'
        }
        {
          name: 'SCM_DO_BUILD_DURING_DEPLOYMENT'
          value: 'true'
        }
      ]
      linuxFxVersion: linuxFxVersion
      alwaysOn: alwaysOn
      ftpsState: ftpsState
      appCommandLine: appCommandLine
      numberOfWorkers: numberOfWorkers != -1 ? numberOfWorkers : null
      minimumElasticInstanceCount: minimumElasticInstanceCount != -1 ? minimumElasticInstanceCount : null
      use32BitWorkerProcess: use32BitWorkerProcess
      functionAppScaleLimit: functionAppScaleLimit != -1 ? functionAppScaleLimit : null
      healthCheckPath: healthCheckPath
      cors: {
        allowedOrigins: union(['https://portal.azure.com', 'https://ms.portal.azure.com'], allowedOrigins)
      }
    }
    clientAffinityEnabled: clientAffinityEnabled
    httpsOnly: true
  }
}

resource sourceControl 'Microsoft.Web/sites/sourcecontrols@2022-03-01' = {
  parent: appService
  name: 'web'
  properties: {
    repoUrl: 'https://github.com/microsoft/sample-app-aoai-chatGPT.git'
    branch: 'main'
    isManualIntegration: true
    deploymentRollbackEnabled: true
  }
}

output name string = appService.name
output uri string = 'https://${appService.properties.defaultHostName}'
