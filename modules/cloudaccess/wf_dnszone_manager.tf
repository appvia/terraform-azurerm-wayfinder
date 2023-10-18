resource "azurerm_role_definition" "dnszonemanager" {
  count = var.enable_dns_zone_manager ? 1 : 0

  name  = "${local.resource_prefix}dnszonemanager${local.resource_suffix}"
  scope = data.azurerm_subscription.primary.id

  permissions {
    actions = [
      "Microsoft.Resources/subscriptions/providers/read",
      "Microsoft.Resources/subscriptions/resourceGroups/read",
      "Microsoft.Resources/subscriptions/resourceGroups/write",
      "Microsoft.Resources/subscriptions/resourceGroups/delete",
      "Microsoft.Network/dnszones/read",
      "Microsoft.Network/dnszones/write",
      "Microsoft.Network/dnszones/delete",
      "Microsoft.Network/dnszones/recordsets/read",
      "Microsoft.Network/dnszones/NS/read",
      "Microsoft.Network/dnszones/NS/write",
      "Microsoft.Network/dnszones/NS/delete"
    ]
  }
}

resource "azurerm_role_assignment" "dnszonemanager" {
  count = var.enable_dns_zone_manager && var.wayfinder_identity_azure_client_id != "" ? 1 : 0

  scope                = data.azurerm_subscription.primary.id
  role_definition_name = azurerm_role_definition.dnszonemanager[0].name
  principal_id         = var.wayfinder_identity_azure_client_id

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
