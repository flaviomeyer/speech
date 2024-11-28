# Mastering Azure OpenAI

This project contains Bicep templates for deploying Azure resources related to Azure OpenAI services. The deployment includes Cognitive Services, App Service, and App Service Plan.

## Project Structure

```plaintext
.
├── README.md
├── bicepconfig.json
├── CD-Bicep.yml
├── modules
│   ├── appService.bicep
│   ├── appServicePlan.bicep
│   ├── cognitiveServicesAccounts.bicep
│   └── cognitiveServicesAccountsDeployments.bicep
└── parameters
    └── parameters.bicepparam
```

## Deployment

### Prerequisites

- **Azure CLI**: Ensure that you have the Azure CLI installed and authenticated.
- **Bicep CLI**: Ensure that you have the Bicep CLI installed.

### Steps

1. **Build Bicep Templates**

   Run the following command to build the Bicep templates:

    ```sh
    bicep build modules/appService.bicep
    bicep build modules/appServicePlan.bicep
    bicep build modules/cognitiveServicesAccounts.bicep
    bicep build modules/cognitiveServicesAccountsDeployments.bicep
    ```

2. **Validate Bicep Templates**

   Use the Azure CLI to validate the Bicep templates:

    ```sh
    az deployment group validate --resource-group <RESOURCE_GROUP_NAME> --template-file <TEMPLATE_FILE_PATH>
    ```

3. **Deploy Resources**

   Deploy the resources using the Azure CLI:

    ```sh
    az deployment group create --resource-group <RESOURCE_GROUP_NAME> --template-file <TEMPLATE_FILE_PATH> --parameters @parameters/parameters.bicepparam
    ```

## Configuration

The Bicep configuration is defined in `bicepconfig.json`.

## CI/CD Pipeline

The CI/CD pipeline is defined in `CD-Bicep.yml`.

## Modules

- **App Service**: `modules/appService.bicep`
- **App Service Plan**: `modules/appServicePlan.bicep`
- **Cognitive Services Accounts**: `modules/cognitiveServicesAccounts.bicep`
- **Cognitive Services Accounts Deployments**: `modules/cognitiveServicesAccountsDeployments.bicep`

## Parameters

The deployment parameters are defined in `parameters/parameters.bicepparam`.

| Parameter Name                       | Type   | Default Value                                                              |
|--------------------------------------|--------|----------------------------------------------------------------------------|
| par_customerShort                    | string |                                                                            |
| par_environment                      | string |                                                                            |
| PAR_SERVICENAMEOAI                   | string | 'oai'                                                                      |
| PAR_SERVICENAMEASP                   | string | 'asp'                                                                      |
| PAR_SERVICENAMEAPP                   | string | 'app'                                                                      |
| par_rgName                           | string | '${par_customerShort}-rgr-${PAR_SERVICENAMEOAI}-${par_environment}-${par_location}-001' |
| par_location                         | string | 'westeurope'                                                               |
| par_cognitiveServicesName            | string | '${par_customerShort}-${PAR_SERVICENAMEOAI}-${par_environment}-${par_location}-001' |
| par_skuName                          | string | 'S0'                                                                       |
| par_kind                             | string | 'OpenAI'                                                                   |
| par_publicNetworkAccess              | string | 'Enabled'                                                                  |
| par_cognitiveServicesDeploymentName  | string | 'gpt-4o'                                                                   |
| par_skuDeploymentName                | string | 'GlobalStandard'                                                           |
| par_skuDeploymentCapacity            | int    | 50                                                                         |
| par_modelVersion                     | string | '2024-08-06'                                                               |
| par_raiPolicyName                    | string | 'Microsoft.DefaultV2'                                                      |
| par_versionUpgradeOption             | string | 'OnceCurrentVersionExpired'                                                |
| par_appServicePlanName               | string | '${par_customerShort}-${PAR_SERVICENAMEASP}-${par_environment}-${par_location}-001' |
| par_appServiceName                   | string | '${par_customerShort}-${PAR_SERVICENAMEAPP}-${par_environment}-${par_location}-001' |
| par_runtimeName                      | string | 'python'                                                                   |
| par_runtimeVersion                   | string | '3.11'                                                                     |
| par_azureOpenAIEndpoint              | string | 'https://${par_cognitiveServicesName}.openai.azure.com/'                   |
| par_azureOpenAIKey                   | string |                                                                            |
