locals {
  clustermanager_definition = jsondecode(file("${path.module}/wf_cluster_manager_definition.json"))
}

resource "azurerm_role_definition" "clustermanager" {
  count = var.enable_cluster_manager ? 1 : 0

  name  = "${local.resource_prefix}clustermanager${local.resource_suffix}"
  scope = data.azurerm_subscription.primary.id

  permissions {
    actions = local.clustermanager_definition.actions
  }
}

resource "azurerm_role_assignment" "clustermanager" {
  count = var.enable_cluster_manager && var.wayfinder_identity_azure_principal_id != "" ? 1 : 0

  scope                = data.azurerm_subscription.primary.id
  role_definition_name = azurerm_role_definition.clustermanager[0].name
  principal_id         = var.wayfinder_identity_azure_principal_id

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
