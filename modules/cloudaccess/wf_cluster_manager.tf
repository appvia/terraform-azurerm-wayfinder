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

resource "time_sleep" "after_azurerm_role_definition_clustermanager" {
  count = var.enable_cluster_manager ? 1 : 0
  depends_on = [
    azurerm_role_definition.clustermanager[0],
  ]

  triggers = {
    "azurerm_role_definition_clustermanager" = jsonencode(keys(azurerm_role_definition.clustermanager[0]))
  }

  create_duration  = var.create_duration_delay["azurerm_role_definition"]
  destroy_duration = var.destroy_duration_delay["azurerm_role_definition"]
}

resource "azurerm_role_assignment" "clustermanager" {
  count = var.enable_cluster_manager && var.from_azure ? 1 : 0

  scope              = data.azurerm_subscription.primary.id
  role_definition_id = azurerm_role_definition.clustermanager[0].role_definition_resource_id
  principal_id       = var.wayfinder_identity_azure_principal_id

  depends_on = [
    time_sleep.after_azurerm_role_definition_clustermanager[0],
    azurerm_role_definition.clustermanager[0]
  ]
}

resource "azurerm_role_assignment" "clustermanager_federated" {
  count = var.enable_cluster_manager && (var.from_aws || var.from_gcp) ? 1 : 0

  scope              = data.azurerm_subscription.primary.id
  role_definition_id = azurerm_role_definition.clustermanager[0].role_definition_resource_id
  principal_id       = azurerm_user_assigned_identity.federated_identity[0].principal_id

  depends_on = [
    time_sleep.after_azurerm_role_definition_clustermanager[0],
    azurerm_role_definition.clustermanager[0],
    azurerm_user_assigned_identity.federated_identity[0],
  ]
}
