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

resource "time_sleep" "after_azurerm_role_definition_dnszonemanager" {
  count = var.enable_dns_zone_manager ? 1 : 0
  depends_on = [
    azurerm_role_definition.dnszonemanager[0],
  ]

  triggers = {
    "azurerm_role_definition_dnszonemanager" = jsonencode(keys(azurerm_role_definition.dnszonemanager[0]))
  }

  create_duration  = var.create_duration_delay["azurerm_role_definition"]
  destroy_duration = var.destroy_duration_delay["azurerm_role_definition"]
}

resource "azurerm_role_assignment" "dnszonemanager" {
  count = var.enable_dns_zone_manager && var.from_azure ? 1 : 0

  scope                = data.azurerm_subscription.primary.id
  role_definition_name = azurerm_role_definition.dnszonemanager[0].name
  principal_id         = var.wayfinder_identity_azure_principal_id

  depends_on = [
    time_sleep.after_azurerm_role_definition_dnszonemanager[0],
    azurerm_role_definition.dnszonemanager[0]
  ]
}

resource "azurerm_role_assignment" "dnszonemanager_federated" {
  count = var.enable_dns_zone_manager && (var.from_aws || var.from_gcp) ? 1 : 0

  scope                = data.azurerm_subscription.primary.id
  role_definition_name = azurerm_role_definition.dnszonemanager[0].name
  principal_id         = azurerm_user_assigned_identity.federated_identity[0].principal_id

  depends_on = [
    time_sleep.after_azurerm_role_definition_dnszonemanager[0],
    azurerm_role_definition.dnszonemanager[0],
    azurerm_user_assigned_identity.federated_identity[0],
  ]
}
