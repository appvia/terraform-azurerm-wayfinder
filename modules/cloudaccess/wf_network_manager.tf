resource "azurerm_role_definition" "networkmanager" {
  count = var.enable_network_manager ? 1 : 0

  name  = "${local.resource_prefix}networkmanager${local.resource_suffix}"
  scope = data.azurerm_subscription.primary.id

  permissions {
    actions = [
      "Microsoft.Authorization/*/read",
      "Microsoft.Insights/alertRules/*",
      "Microsoft.Network/*",
      "Microsoft.ResourceHealth/availabilityStatuses/read",
      "Microsoft.Resources/deployments/*",
      "Microsoft.Resources/subscriptions/resourceGroups/read",
      "Microsoft.Resources/subscriptions/resourceGroups/write",
      "Microsoft.Resources/subscriptions/resourceGroups/delete",
      "Microsoft.Support/*",
      "Microsoft.Resources/subscriptions/providers/read"
    ]
  }
}

resource "azurerm_role_assignment" "networkmanager" {
  count = var.enable_network_manager && var.wayfinder_identity_azure_client_id != "" ? 1 : 0

  scope                = data.azurerm_subscription.primary.id
  role_definition_name = azurerm_role_definition.networkmanager[0].name
  principal_id         = var.wayfinder_identity_azure_client_id

  depends_on = [
    azurerm_role_definition.networkmanager[0]
  ]
}

resource "azurerm_role_assignment" "networkmanager_federated" {
  count = var.enable_cloud_info && (local.create_aws_trust || local.create_gcp_trust) ? 1 : 0

  scope                = data.azurerm_subscription.primary.id
  role_definition_name = azurerm_role_definition.networkmanager[0].name
  principal_id         = azurerm_user_assigned_identity.federated_identity[0].principal_id

  depends_on = [
    azurerm_role_definition.dnszonemanager[0],
    azurerm_user_assigned_identity.federated_identity[0],
  ]
}
