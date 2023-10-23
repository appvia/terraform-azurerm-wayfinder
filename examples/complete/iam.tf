resource "azurerm_user_assigned_identity" "aks_identity" {
  count               = var.user_assigned_identity == null ? 1 : 0
  resource_group_name = var.resource_group_name
  location            = var.location

  name = "msi-wayfinder-${var.environment}"
}

resource "azurerm_role_assignment" "private_dns" {
  count                = var.user_assigned_identity == null ? 1 : 0
  scope                = data.azurerm_private_dns_zone.wayfinder[0].id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_identity[0].principal_id
}
