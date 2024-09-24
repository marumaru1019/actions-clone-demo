// main.bicep
param location string = resourceGroup().location
param webAppName string = 'app-actions-sample'
param appServicePlanName string = 'ActionsAppServicePlan'

// App Service Plan
resource appServicePlan 'Microsoft.Web/serverfarms@2023-05-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'B1'
    tier: 'Basic'
  }
}

// Web App
resource webApp 'Microsoft.Web/sites@2023-05-01' = {
  name: webAppName
  location: location
  kind: 'app,linux'
  properties: {
    serverFarmId: appServicePlan.id
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
      startupCommand: 'uvicorn main:app --host=0.0.0.0 --port $PORT'
    }
  }
}
