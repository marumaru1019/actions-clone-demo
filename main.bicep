// main.bicep
param location string = resourceGroup().location
param webAppName string = 'app-actions-sample'
param appServicePlanName string = 'ActionsAppServicePlan'

@description('Enable public network access')
param enablePublicNetworkAccess bool = true

// App Service Plan
resource appServicePlan 'Microsoft.Web/serverfarms@2023-06-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'B1'
    tier: 'Basic'
  }
}

// Web App
resource webApp 'Microsoft.Web/sites@2023-06-01' = {
  name: webAppName
  location: location
  kind: 'app,linux'
  properties: {
    serverFarmId: appServicePlan.id
    publicNetworkAccess: enablePublicNetworkAccess ? 'Enabled' : 'Disabled'
  }
}

// Site Configuration
resource siteConfig 'Microsoft.Web/sites/config@2023-06-01' = {
  name: '${webAppName}/web'
  properties: {
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
    startupCommand: 'uvicorn main:app --host=0.0.0.0 --port $PORT'
  }
}
