resource "azurerm_user_assigned_identity" "aks_identity" {
  count               = var.user_assigned_identity == null ? 1 : 0
  resource_group_name = var.resource_group_name
  location            = var.location

  name = "msi-wayfinder-${var.environment}"
}
