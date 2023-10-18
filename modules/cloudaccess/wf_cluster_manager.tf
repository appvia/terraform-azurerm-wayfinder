resource "azurerm_role_definition" "clustermanager" {
  count = var.enable_cluster_manager ? 1 : 0

  name  = "${local.resource_prefix}clustermanager${local.resource_suffix}"
  scope = data.azurerm_subscription.primary.id
  permissions {
    actions = [
      "Microsoft.Resources/subscriptions/providers/read",
      "Microsoft.Resources/subscriptions/resourceGroups/read",
      "Microsoft.Resources/subscriptions/resourceGroups/write",
      "Microsoft.Resources/subscriptions/resourceGroups/delete",
      "Microsoft.ContainerService/managedClusters/agentPools/read",
      "Microsoft.ContainerService/managedClusters/agentPools/write",
      "Microsoft.ContainerService/managedClusters/agentPools/delete",
      "Microsoft.ContainerService/managedClusters/read",
      "Microsoft.ContainerService/managedClusters/write",
      "Microsoft.ContainerService/managedClusters/delete",
      "Microsoft.ContainerService/managedClusters/listClusterAdminCredential/action",
      "Microsoft.ManagedIdentity/userAssignedIdentities/read",
      "Microsoft.ManagedIdentity/userAssignedIdentities/write",
      "Microsoft.ManagedIdentity/userAssignedIdentities/delete",
      "Microsoft.Authorization/roleAssignments/read",
      "Microsoft.Authorization/roleAssignments/write",
      "Microsoft.Authorization/roleAssignments/delete",
      "Microsoft.ContainerService/register/action",
      "Microsoft.Compute/register/action",
      "Microsoft.Compute/unregister/action",
      "Microsoft.Resources/providers/read",
      "Microsoft.Storage/register/action",
      "Microsoft.Features/register/action",
      "Microsoft.Features/providers/features/register/action",
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ]
  }
}

resource "azurerm_role_assignment" "clustermanager" {
  count = var.enable_cluster_manager && var.wayfinder_identity_azure_client_id != "" ? 1 : 0

  scope                = data.azurerm_subscription.primary.id
  role_definition_name = azurerm_role_definition.clustermanager[0].name
  principal_id         = var.wayfinder_identity_azure_client_id

  depends_on = [
    azurerm_role_definition.clustermanager[0]
  ]
}

resource "azurerm_role_assignment" "clustermanager_federated" {
  count = var.enable_cloud_info && (local.create_aws_trust || local.create_gcp_trust) ? 1 : 0

  scope                = data.azurerm_subscription.primary.id
  role_definition_name = azurerm_role_definition.clustermanager[0].name
  principal_id         = azurerm_user_assigned_identity.federated_identity[0].principal_id

  depends_on = [
    azurerm_role_definition.clustermanager[0],
    azurerm_user_assigned_identity.federated_identity[0],
  ]
}
