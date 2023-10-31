resource "azurerm_user_assigned_identity" "aks_identity" {
  count               = var.user_assigned_identity == null ? 1 : 0
  resource_group_name = var.resource_group_name
  location            = var.location

  name = "msi-wayfinder-${var.environment}"
}

resource "azurerm_role_assignment" "private_dns" {
  count                = var.private_dns_zone_id == null ? 0 : 1
  scope                = var.private_dns_zone_id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = var.user_assigned_identity == null ? azurerm_user_assigned_identity.aks_identity[0].principal_id : var.user_assigned_identity
}
