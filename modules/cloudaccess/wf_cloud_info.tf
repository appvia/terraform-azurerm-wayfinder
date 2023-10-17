resource "azurerm_role_definition" "cloudinfo" {
  count = var.enable_cloud_info ? 1 : 0

  name  = "${local.resource_prefix}cloudinfo${local.resource_suffix}"
  scope = data.azurerm_subscription.primary.id

  permissions {
    actions = [
      "Microsoft.Commerce/RateCard/read",
      "Microsoft.Compute/virtualMachines/vmSizes/read",
      "Microsoft.ContainerService/containerServices/read",
      "Microsoft.Resources/providers/read",
      "Microsoft.Resources/subscriptions/locations/read",
      "Microsoft.Resources/subscriptions/providers/read"
    ]
  }
}

resource "azurerm_role_assignment" "cloudinfo" {
  count = var.enable_cloud_info && var.wayfinder_identity_azure_client_id != "" ? 1 : 0

  scope                = data.azurerm_subscription.primary.id
  role_definition_name = azurerm_role_definition.cloudinfo[0].name
  principal_id         = var.wayfinder_identity_azure_client_id

  depends_on = [
    azurerm_role_definition.cloudinfo[0]
  ]
}

resource "azurerm_role_assignment" "cloudinfo_federated" {
  count = var.enable_cloud_info && (local.create_aws_trust || local.create_gcp_trust) ? 1 : 0

  scope                = data.azurerm_subscription.primary.id
  role_definition_name = azurerm_role_definition.cloudinfo[0].name
  principal_id         = azurerm_user_assigned_identity.federated_identity[0].principal_id

  depends_on = [
    azurerm_role_definition.cloudinfo[0],
    azurerm_user_assigned_identity.federated_identity[0],
  ]
}