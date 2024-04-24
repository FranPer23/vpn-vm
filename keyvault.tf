data "azurerm_key_vault" "keyvaultnew" {
    name                        = "mynewkeyvault2404202411"
    resource_group_name         = "fran-rg" 
}

data "azurerm_key_vault_secret" "myabsolutesecret" {
  name         = "myverysecretsecret"
  key_vault_id = data.azurerm_key_vault.keyvaultnew.id
}

output "un_nome_qualsiasi" {
  value = data.azurerm_key_vault_secret.myabsolutesecret.value
  sensitive = true # questo me lo ha detto terraform di metterlo

}

# data "azurerm_key_vault_secret" "examplesecret" {
#     name = "mysecret"
#     key_vault_id = "/<sub_id>/resourceGroups/<rg_name>/providers/Microsoft.KeyVault/vaults/<keyvault_name>"
# }

# output "secretvalue" {
#   value = data.azurerm_key_vault_secret.examplesecret.value
#   sensitive = true # questo me lo ha detto terraform di metterlo
# }