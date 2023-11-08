locals {
  peeringacceptor_definition = jsondecode(file("${path.module}/wf_peering_acceptor_definition.json"))
}

resource "azurerm_role_definition" "peeringacceptor" {
  count = var.enable_peering_acceptor ? 1 : 0

  name  = "${local.resource_prefix}peeringacceptor${local.resource_suffix}"
  scope = data.azurerm_subscription.primary.id

  permissions {
    actions = local.peeringacceptor_definition.actions
  }
}

resource "time_sleep" "after_azurerm_role_definition_peeringacceptor" {
  count = var.enable_peering_acceptor ? 1 : 0
  depends_on = [
    azurerm_role_definition.peeringacceptor[0],
  ]

  triggers = {
    "azurerm_role_definition_peeringacceptor" = jsonencode(keys(azurerm_role_definition.peeringacceptor[0]))
  }

  create_duration  = var.create_duration_delay["azurerm_role_definition"]
  destroy_duration = var.destroy_duration_delay["azurerm_role_definition"]
}

resource "azurerm_role_assignment" "peeringacceptor" {
  count = var.enable_peering_acceptor && var.from_azure ? 1 : 0

  scope                = data.azurerm_subscription.primary.id
  role_definition_name = azurerm_role_definition.peeringacceptor[0].name
  principal_id         = var.wayfinder_identity_azure_principal_id

  depends_on = [
    time_sleep.after_azurerm_role_definition_peeringacceptor[0],
    azurerm_role_definition.peeringacceptor[0]
  ]
}

resource "azurerm_role_assignment" "peeringacceptor_federated" {
  count = var.enable_peering_acceptor && (var.from_aws || var.from_gcp) ? 1 : 0

  scope                = data.azurerm_subscription.primary.id
  role_definition_name = azurerm_role_definition.peeringacceptor[0].name
  principal_id         = azurerm_user_assigned_identity.federated_identity[0].principal_id

  depends_on = [
    time_sleep.after_azurerm_role_definition_peeringacceptor[0],
    azurerm_role_definition.peeringacceptor[0],
    azurerm_user_assigned_identity.federated_identity[0],
  ]
}
