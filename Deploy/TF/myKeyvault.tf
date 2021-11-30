resource "azurerm_key_vault" "myKeyVault" {
  name                        = "${var.app_name}-kv"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"  
}

# Keyvault Owner = Deployment credentials owner
resource "azurerm_key_vault_access_policy" "keyvault_policy_owner" {
  key_vault_id = azurerm_key_vault.myKeyVault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  lifecycle {
    create_before_destroy = true
  }

  key_permissions = [
    "Get",
  ]

  secret_permissions = [
    "Get", "Set", "List", "Delete", "Recover", "Backup", "Restore", "Purge"
  ]

  storage_permissions = [
    "Get",
  ]
}

# Add my-secret
resource "azurerm_key_vault_secret" "keyvault_secret" {
  name         = "my-secret"
  value        = "Set from KeyVault!!! Hello ${var.app_name}"
  key_vault_id = azurerm_key_vault.myKeyVault.id
  depends_on = [
    azurerm_key_vault_access_policy.keyvault_policy_owner
  ]
  # lifecycle {
  #   ignore_changes = [value, version]
  # }
}