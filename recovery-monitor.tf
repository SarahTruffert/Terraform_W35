# resource "azurerm_data_protection_backup_vault" "backup-vault" {
#   name                = "backup-vault"
#   location            = var.location
#   resource_group_name = var.rg_name
#   datastore_type      = "VaultStore"
#   redundancy          = "LocallyRedundant"
# }

# data "azurerm_subscription" "primary" {
# }

# data "azurerm_client_config" "example" {
# }

# resource "azurerm_role_assignment" "azurerm_role_assignment" {
#   scope                = data.azurerm_subscription.primary.id
#   role_definition_name = "Disk Snapshot Contributor"
#   # principal_id         = azurerm_data_protection_backup_vault.backup-vault.identity[0].principal_id
#   principal_id         = data.azurerm_client_config.example.object_id
# }

# # Backup policy disk monitor :
# resource "azurerm_data_protection_backup_policy_disk" "backup_policy_disk_m" {
#   name                = "backup-policy-disk-m"
#   vault_id = azurerm_data_protection_backup_vault.backup-vault.id
#   backup_repeating_time_intervals = ["R/2021-05-19T06:33:16+00:00/PT4H"]
#   default_retention_duration      = "P7D"
#    }

# # Backup policy disk vms :
# resource "azurerm_data_protection_backup_policy_disk" "backup_policy_disk_vms" {
#   name                = "backup-policy-disk-vms"
#   vault_id = azurerm_data_protection_backup_vault.backup-vault.id
#   backup_repeating_time_intervals = ["R/2021-05-19T06:33:16+00:00/PT4H"]
#   default_retention_duration      = "P7D"
# }

# # Monitor
# resource "azurerm_data_protection_backup_instance_disk" "backup_instance_disk_m" {
#   name                         = "backup_instance_disk_m"
#   location                     = var.location
#   vault_id                     = azurerm_data_protection_backup_vault.backup-vault.id
#   disk_id                      = azurerm_managed_disk.managed_disk_monitor.id
#   snapshot_resource_group_name = var.rg_name
#   backup_policy_id             = azurerm_data_protection_backup_policy_disk.backup_policy_disk_m.id
# }

# # Vms
# resource "azurerm_data_protection_backup_instance_disk" "backup_instance_disk_vms" {
#   name                         = "backup_instance_disk_vms"
#   location                     = var.location
#   vault_id                     = azurerm_data_protection_backup_vault.backup-vault.id
#   for_each = var.vm_names
#   disk_id    = azurerm_managed_disk.managed_disk[each.key].id
#   snapshot_resource_group_name = var.rg_name
#   backup_policy_id             = azurerm_data_protection_backup_policy_disk.backup_policy_disk_vms.id
# }


# resource "azurerm_recovery_services_vault" "recovery" {
#   name = "nique-ta-mother"
#   location            = var.location
#   resource_group_name = var.rg_name
#   sku                 = "Standard"
# }