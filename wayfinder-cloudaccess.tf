resource "azurerm_role_definition" "wayfinder_dns_zone_manager" {
  count       = var.enable_wf_cloudaccess ? 1 : 0
  name        = "WayfinderDNSZoneManager-${var.wayfinder_instance_id}"
  scope       = data.azurerm_subscription.current.id
  description = "Wayfinder managed access to create DNS Zones in Azure"

  permissions {
    actions = [
      "Microsoft.Network/dnszones/delete",
      "Microsoft.Network/dnszones/NS/delete",
      "Microsoft.Network/dnszones/NS/read",
      "Microsoft.Network/dnszones/NS/write",
      "Microsoft.Network/dnszones/read",
      "Microsoft.Network/dnszones/recordsets/read",
      "Microsoft.Network/dnszones/TXT/delete",
      "Microsoft.Network/dnszones/TXT/read",
      "Microsoft.Network/dnszones/TXT/write",
      "Microsoft.Network/dnszones/write",
      "Microsoft.Resources/subscriptions/providers/read",
      "Microsoft.Resources/subscriptions/resourceGroups/delete",
      "Microsoft.Resources/subscriptions/resourceGroups/read",
      "Microsoft.Resources/subscriptions/resourceGroups/write"
    ]
    not_actions = []
  }
}

resource "azurerm_role_assignment" "wayfinder_dns_zone_manager" {
  count                = var.enable_wf_cloudaccess ? 1 : 0
  depends_on           = [time_sleep.after_azurerm_role_definition]
  scope                = data.azurerm_subscription.current.id
  role_definition_name = azurerm_role_definition.wayfinder_dns_zone_manager[0].name
  principal_id         = azurerm_user_assigned_identity.wayfinder_main.principal_id
}

resource "azurerm_role_definition" "wayfinder_cloud_info" {
  count       = var.enable_wf_cloudaccess ? 1 : 0
  name        = "WayfinderCloudInfo-${var.wayfinder_instance_id}"
  scope       = data.azurerm_subscription.current.id
  description = "Wayfinder managed access to obtain cloud metadata like prices"

  permissions {
    actions = [
      "Microsoft.Commerce/RateCard/read",
      "Microsoft.Compute/virtualMachines/vmSizes/read",
      "Microsoft.ContainerService/containerServices/read",
      "Microsoft.Resources/providers/read",
      "Microsoft.Resources/subscriptions/locations/read",
      "Microsoft.Resources/subscriptions/providers/read"
    ]
    not_actions = []
  }
}

resource "azurerm_role_assignment" "wayfinder_cloud_info" {
  count                = var.enable_wf_cloudaccess ? 1 : 0
  depends_on           = [time_sleep.after_azurerm_role_definition]
  scope                = data.azurerm_subscription.current.id
  role_definition_name = azurerm_role_definition.wayfinder_cloud_info[0].name
  principal_id         = azurerm_user_assigned_identity.wayfinder_main.principal_id
}

resource "kubectl_manifest" "wayfinder_cloud_identity_main" {
  count      = var.enable_k8s_resources && var.enable_wf_cloudaccess ? 1 : 0
  depends_on = [helm_release.wayfinder]

  yaml_body = templatefile("${path.module}/manifests/wayfinder-cloud-identity.yml.tpl", {
    name        = "cloudidentity-azure"
    description = "Cloud managed identity"
    client_id   = azurerm_user_assigned_identity.wayfinder_main.client_id
    tenant_id   = data.azurerm_subscription.current.tenant_id
  })
}

resource "kubectl_manifest" "wayfinder_azure_cloudinfo_cloudaccessconfig" {
  count      = var.enable_k8s_resources && var.enable_wf_cloudaccess ? 1 : 0
  depends_on = [time_sleep.after_kubectl_manifest_cloud_identity]

  yaml_body = templatefile("${path.module}/manifests/wayfinder-azure-cloudinfo-cloudaccessconfig.yml.tpl", {
    region          = var.location
    subscription_id = data.azurerm_subscription.current.subscription_id
    tenant_id       = data.azurerm_subscription.current.tenant_id
    identity        = "cloudidentity-azure"
  })
}

resource "kubectl_manifest" "wayfinder_azure_dnszonemanagement_cloudaccessconfig" {
  count      = var.enable_k8s_resources && var.enable_wf_cloudaccess ? 1 : 0
  depends_on = [time_sleep.after_kubectl_manifest_cloud_identity]

  yaml_body = templatefile("${path.module}/manifests/wayfinder-azure-dnszonemanagement-cloudaccessconfig.yml.tpl", {
    region          = var.location
    subscription_id = data.azurerm_subscription.current.subscription_id
    tenant_id       = data.azurerm_subscription.current.tenant_id
    identity        = "cloudidentity-azure"
  })
}
