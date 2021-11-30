resource "azurerm_storage_account" "myStorage" {
  name                     = "${var.app_name}${var.loc}lrs"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  account_tier = "Standard"
  account_replication_type = "LRS"
  tags = local.common_tags
}

# Add my-storage
resource "azurerm_key_vault_secret" "myStorageSecret" {
  name         = "my-storage"
  value        = azurerm_storage_account.myStorage.primary_connection_string
  key_vault_id = azurerm_key_vault.myKeyVault.id
  depends_on = [
    azurerm_key_vault_access_policy.keyvault_policy_owner,
    azurerm_storage_account.myStorage
  ]
  # lifecycle {
  #   ignore_changes = [value, version]
  # }
}