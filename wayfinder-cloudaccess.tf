module "wayfinder_azure_cloudaccess" {
  source = "./modules/cloudaccess"
  count  = var.enable_wf_cloudaccess ? 1 : 0

  resource_suffix                       = var.wayfinder_instance_id
  wayfinder_identity_azure_principal_id = azurerm_user_assigned_identity.wayfinder_main.principal_id
  region                                = var.location
  create_duration_delay                 = { azurerm_role_definition = var.create_duration_delay.azurerm_role_definition }
  destroy_duration_delay                = { azurerm_role_definition = var.destroy_duration_delay.azurerm_role_definition }

  enable_dns_zone_manager = true
  enable_cloud_info       = true
  enable_cluster_manager  = false
  enable_network_manager  = false
}

resource "kubectl_manifest" "wayfinder_cloud_identity_main" {
  count      = var.enable_k8s_resources && var.enable_wf_cloudaccess ? 1 : 0
  depends_on = [helm_release.wayfinder]

  yaml_body = templatefile("${path.module}/manifests/wayfinder-cloud-identity.yml.tpl", {
    name         = "cloudidentity-azure"
    description  = "Cloud managed identity"
    client_id    = azurerm_user_assigned_identity.wayfinder_main.client_id
    tenant_id    = data.azurerm_subscription.current.tenant_id
    principal_id = azurerm_user_assigned_identity.wayfinder_main.principal_id
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
