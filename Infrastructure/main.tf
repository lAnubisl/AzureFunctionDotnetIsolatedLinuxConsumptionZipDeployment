terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.45.0"
    }
  }
  required_version = "= 1.4.6"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-func-dotnet-deployment-test"
  location = "westeurope"
}

resource "azurerm_storage_account" "st_func" {
  name                            = "stfuncdotnetdeployment"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false
}

resource "azurerm_service_plan" "func_plan" {
  name                = "plan-func-dotnet-deployment-test"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "func" {
  name                       = "func-dotnet-deployment-test"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  service_plan_id            = azurerm_service_plan.func_plan.id
  storage_account_name       = azurerm_storage_account.st_func.name
  storage_account_access_key = azurerm_storage_account.st_func.primary_access_key
  app_settings = {
    AzureWebJobsFeatureFlags       = "EnableWorkerIndexing"
    FUNCTIONS_WORKER_RUNTIME       = "dotnet-isolated"
    SCM_DO_BUILD_DURING_DEPLOYMENT = "false"
  }
  site_config {
    ftps_state = "Disabled"
    application_stack {
      dotnet_version              = "6.0"
      use_dotnet_isolated_runtime = true
    }
  }
}