locals {
  privatelinkmanager_definition = jsondecode(file("${path.module}/wf_privatelink_manager_definition.json"))
}

resource "azurerm_role_definition" "privatelinkmanager" {
  count = var.enable_private_link_manager ? 1 : 0

  name  = "${local.resource_prefix}privatelinkmanager${local.resource_suffix}"
  scope = data.azurerm_subscription.primary.id

  permissions {
    actions = local.privatelinkmanager_definition.actions
  }
}

resource "time_sleep" "after_azurerm_role_definition_privatelinkmanager" {
  count = var.enable_private_link_manager ? 1 : 0
  depends_on = [
    azurerm_role_definition.privatelinkmanager[0],
  ]

  triggers = {
    "azurerm_role_definition_privatelinkmanager" = jsonencode(keys(azurerm_role_definition.privatelinkmanager[0]))
  }

  create_duration  = var.create_duration_delay["azurerm_role_definition"]
  destroy_duration = var.destroy_duration_delay["azurerm_role_definition"]
}

resource "azurerm_role_assignment" "privatelinkmanager" {
  count = var.enable_private_link_manager && var.from_azure ? 1 : 0

  scope                = data.azurerm_subscription.primary.id
  role_definition_name = azurerm_role_definition.privatelinkmanager[0].name
  principal_id         = var.wayfinder_identity_azure_principal_id

  depends_on = [
    time_sleep.after_azurerm_role_definition_privatelinkmanager[0],
    azurerm_role_definition.privatelinkmanager[0],
  ]
}