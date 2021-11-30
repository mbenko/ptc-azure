resource "azurerm_app_service_plan" "plan" {
  name                = "tf-${var.app_name}-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    tier = "Free"
    size = "F1"
  }
}

resource "azurerm_app_service" "myApp" {
  name                = "tf-${var.app_name}-site"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.plan.id

  app_settings = {
    "EnvName"       = "Terraform and Key Vault"
    "FavoriteColor" = "PaleTurquoise"
    "my-secret"     = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.keyvault_secret.versionless_id})"
  }
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_key_vault_access_policy" "keyvault_policy_myApp" {
  key_vault_id = azurerm_key_vault.myKeyVault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_app_service.myApp.identity[0].principal_id
  secret_permissions = [
    "Get"
  ]
}