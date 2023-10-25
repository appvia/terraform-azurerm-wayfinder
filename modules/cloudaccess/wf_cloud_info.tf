locals {
  cloudinfo_definition = jsondecode(file("${path.module}/wf_cloud_info_definition.json"))
}

resource "azurerm_role_definition" "cloudinfo" {
  count = var.enable_cloud_info ? 1 : 0

  name  = "${local.resource_prefix}cloudinfo${local.resource_suffix}"
  scope = data.azurerm_subscription.primary.id

  permissions {
    actions = local.cloudinfo_definition.actions
  }
}

resource "time_sleep" "after_azurerm_role_definition_cloudinfo" {
  count = var.enable_cloud_info ? 1 : 0
  depends_on = [
    azurerm_role_definition.cloudinfo[0],
  ]

  triggers = {
    "azurerm_role_definition_cloudinfo" = jsonencode(keys(azurerm_role_definition.cloudinfo[0]))
  }

  create_duration  = var.create_duration_delay["azurerm_role_definition"]
  destroy_duration = var.destroy_duration_delay["azurerm_role_definition"]
}

resource "azurerm_role_assignment" "cloudinfo" {
  count = var.enable_cloud_info && var.from_azure ? 1 : 0

  scope                = data.azurerm_subscription.primary.id
  role_definition_name = azurerm_role_definition.cloudinfo[0].name
  principal_id         = var.wayfinder_identity_azure_principal_id

  depends_on = [
    time_sleep.after_azurerm_role_definition_cloudinfo[0],
    azurerm_role_definition.cloudinfo[0],
  ]
}

resource "azurerm_role_assignment" "cloudinfo_federated" {
  count = var.enable_cloud_info && (var.from_aws || var.from_gcp) ? 1 : 0

  scope                = data.azurerm_subscription.primary.id
  role_definition_name = azurerm_role_definition.cloudinfo[0].name
  principal_id         = azurerm_user_assigned_identity.federated_identity[0].principal_id

  depends_on = [
    time_sleep.after_azurerm_role_definition_cloudinfo[0],
    azurerm_role_definition.cloudinfo[0],
    azurerm_user_assigned_identity.federated_identity[0],
  ]
}