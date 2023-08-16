data "azurerm_subscription" "current" {}

locals {
  name = format("wayfinder-%s", var.environment)

  tags = merge({
    Provisioner = "Terraform"
    Environment = var.environment
  }, var.tags)

  wayfinder_instance_id = var.wayfinder_instance_id != "" ? var.wayfinder_instance_id : substr(md5(format("azure-%s-%s", var.resource_group_id, var.environment)), 0, 12)
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

  create_duration  = var.create_duration_delay["azurerm_role_definition"]
  destroy_duration = var.destroy_duration_delay["azurerm_role_definition"]
}

resource "time_sleep" "after_kubectl_manifest_cloud_identity" {
  count = var.enable_k8s_resources ? 1 : 0
  depends_on = [
    kubectl_manifest.wayfinder_cloud_identity_cloud_info,
    kubectl_manifest.wayfinder_cloud_identity_dns_zone_manager,
    kubectl_manifest.wayfinder_cloud_identity_main,
    kubectl_manifest.wayfinder_cloud_identity_none,
  ]

  triggers = {
    "kubectl_manifest_wayfinder_cloud_identity_cloud_info"       = jsonencode(keys(kubectl_manifest.wayfinder_cloud_identity_cloud_info[0]))
    "kubectl_manifest_wayfinder_cloud_identity_dns_zone_manager" = jsonencode(keys(kubectl_manifest.wayfinder_cloud_identity_dns_zone_manager[0]))
    "kubectl_manifest_wayfinder_cloud_identity_main"             = jsonencode(keys(kubectl_manifest.wayfinder_cloud_identity_main[0]))
    "kubectl_manifest_wayfinder_cloud_identity_none"             = jsonencode(keys(kubectl_manifest.wayfinder_cloud_identity_none[0]))
  }

  create_duration  = var.create_duration_delay["kubectl_manifest_cloud_identity"]
  destroy_duration = var.destroy_duration_delay["kubectl_manifest_cloud_identity"]
}
