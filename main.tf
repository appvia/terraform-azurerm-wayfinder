data "azurerm_subscription" "current" {}

locals {
  name = format("wayfinder-%s", var.environment)

  tags = merge({
    Provisioner = "Terraform"
    Environment = var.environment
  }, var.tags)

  wayfinder_instance_id = var.wayfinder_instance_id != "" ? var.wayfinder_instance_id : substr(md5(format("azure-%s-%s", var.resource_group_id, var.environment)), 0, 12)

  create_duration_delay = {
    after_azurerm_role_definition = var.create_duration_delay["azurerm_role_definition"]
  }
  destroy_duration_delay = {
    after_azurerm_role_definition = var.destroy_duration_delay["azurerm_role_definition"]
  }
}

resource "time_sleep" "after_azurerm_role_definition" {
  depends_on = [
    azurerm_role_definition.wayfinder_cloud_info,
    azurerm_role_definition.wayfinder_dns_zone_manager,
    azurerm_role_definition.wayfinder_main,
    azurerm_role_definition.wayfinder_none,
  ]

  triggers = {
    "azurerm_role_definition_wayfinder_cloud_info"       = jsonencode(keys(azurerm_role_definition.wayfinder_cloud_info))
    "azurerm_role_definition_wayfinder_dns_zone_manager" = jsonencode(keys(azurerm_role_definition.wayfinder_dns_zone_manager))
    "azurerm_role_definition_wayfinder_main"             = jsonencode(keys(azurerm_role_definition.wayfinder_main))
    "azurerm_role_definition_wayfinder_none"             = jsonencode(keys(azurerm_role_definition.wayfinder_none))
  }

  create_duration  = local.create_duration_delay["after_azurerm_role_definition"]
  destroy_duration = local.destroy_duration_delay["after_azurerm_role_definition"]
}
