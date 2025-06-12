resource "azurerm_role_assignment" "custom" {
  for_each = { for idx, role in var.custom_roles : idx => role }

  scope              = each.value.scope
  role_definition_id = each.value.role_definition_id
  principal_id       = var.wayfinder_identity_azure_principal_id

  depends_on = [
    azurerm_user_assigned_identity.federated_identity
  ]
}

resource "azurerm_role_assignment" "custom_federated" {
  for_each = { for idx, role in var.custom_roles : idx => role if var.from_aws || var.from_gcp }

  scope              = each.value.scope
  role_definition_id = each.value.role_definition_id
  principal_id       = azurerm_user_assigned_identity.federated_identity[0].principal_id

  depends_on = [
    azurerm_user_assigned_identity.federated_identity
  ]
} 