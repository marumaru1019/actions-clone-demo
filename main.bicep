// main.bicep
param location string = resourceGroup().location
param webAppName string = 'app-actions-sample'
param appServicePlanName string = 'ActionsAppServicePlan'

@description('Enable public network access')
param enablePublicNetworkAccess bool = true

// App Service Plan
resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'P1v2'
    tier: 'PremiumV2'
    size: 'P1v2'
    capacity: 1
  }
}

// Web App
resource webApp 'Microsoft.Web/sites@2022-09-01' = {
  name: webAppName
  location: location
  kind: 'app,linux'
  properties: {
    serverFarmId: appServicePlan.id
    publicNetworkAccess: enablePublicNetworkAccess ? 'Enabled' : 'Disabled'
    siteConfig: {
      linuxFxVersion: 'PYTHON|3.11'
      appSettings: [
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '1'
        }
        {
          name: 'PORT'
          value: '8000'
        }
      ]
      appCommandLine: 'uvicorn main:app --host=0.0.0.0 --port $PORT'
    }
  }
}
