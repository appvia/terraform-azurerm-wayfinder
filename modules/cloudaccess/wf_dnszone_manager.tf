locals {
  dnszonemanager_definition = jsondecode(file("${path.module}/wf_dnszone_manager_definition.json"))
}

resource "azurerm_role_definition" "dnszonemanager" {
  count = var.enable_dns_zone_manager ? 1 : 0

  name  = "${local.resource_prefix}dnszonemanager${local.resource_suffix}"
  scope = data.azurerm_subscription.primary.id

  permissions {
    actions = local.dnszonemanager_definition.actions
  }
}

resource "azurerm_role_assignment" "dnszonemanager" {
  count = var.enable_dns_zone_manager && var.wayfinder_identity_azure_principal_id != "" ? 1 : 0

  scope                = data.azurerm_subscription.primary.id
  role_definition_name = azurerm_role_definition.dnszonemanager[0].name
  principal_id         = var.wayfinder_identity_azure_principal_id

  depends_on = [
    azurerm_role_definition.dnszonemanager[0]
  ]
}

resource "azurerm_role_assignment" "dnszonemanager_federated" {
  count = var.enable_cloud_info && (local.create_aws_trust || local.create_gcp_trust) ? 1 : 0

  scope                = data.azurerm_subscription.primary.id
  role_definition_name = azurerm_role_definition.dnszonemanager[0].name
  principal_id         = azurerm_user_assigned_identity.federated_identity[0].principal_id

  depends_on = [
    azurerm_role_definition.dnszonemanager[0],
    azurerm_user_assigned_identity.federated_identity[0],
  ]
}
