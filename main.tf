data "azurerm_subscription" "current" {}

locals {
  name = format("wayfinder-%s", var.environment)

  tags = merge({
    Provisioner = "Terraform"
    Environment = var.environment
  }, var.tags)

  resource_group_id = "${data.azurerm_subscription.current.id}/resourceGroups/${var.resource_group_name}"

  # If no DNS resource group provided, default to the same resource group as Wayfinder
  dns_resource_group_id   = var.dns_resource_group_id == "" ? local.resource_group_id : var.dns_resource_group_id
  dns_resource_group_name = reverse(split("/", local.dns_resource_group_id))[0]

  # if not provided, use the same resource group as the AKS cluster
  private_link_resourcegroup = var.private_link_resourcegroup == "" ? var.resource_group_name : var.private_link_resourcegroup

  cloudidentity_name = "cloudidentity-azure"
}

resource "time_sleep" "after_azurerm_role_definition_main" {
  depends_on = [
    azurerm_role_definition.wayfinder_main,
  ]

  triggers = {
    "azurerm_role_definition_wayfinder_main" = jsonencode(keys(azurerm_role_definition.wayfinder_main))
  }

  create_duration  = var.create_duration_delay["azurerm_role_definition"]
  destroy_duration = var.destroy_duration_delay["azurerm_role_definition"]
}

resource "time_sleep" "after_kubectl_manifest_cloud_identity" {
  count = var.enable_k8s_resources && var.enable_wf_cloudaccess ? 1 : 0
  depends_on = [
    kubectl_manifest.wayfinder_cloud_identity_main,
  ]

  triggers = {
    "kubectl_manifest_wayfinder_cloud_identity_main" = jsonencode(keys(kubectl_manifest.wayfinder_cloud_identity_main[0]))
  }

  create_duration  = var.create_duration_delay["kubectl_manifest_cloud_identity"]
  destroy_duration = var.destroy_duration_delay["kubectl_manifest_cloud_identity"]
}
