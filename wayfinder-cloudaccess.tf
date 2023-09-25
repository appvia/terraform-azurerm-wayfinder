resource "azurerm_user_assigned_identity" "wayfinder_dns_zone_manager" {
  location            = var.location
  resource_group_name = module.aks.node_resource_group
  name                = "wf-admin-dnszonemanager-${var.wayfinder_instance_id}"
  tags                = var.tags
}

resource "azurerm_role_definition" "wayfinder_dns_zone_manager" {
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
  depends_on           = [time_sleep.after_azurerm_role_definition]
  scope                = data.azurerm_subscription.current.id
  role_definition_name = azurerm_role_definition.wayfinder_dns_zone_manager.name
  principal_id         = azurerm_user_assigned_identity.wayfinder_dns_zone_manager.principal_id
}

resource "azurerm_user_assigned_identity" "wayfinder_cloud_info" {
  location            = var.location
  resource_group_name = module.aks.node_resource_group
  name                = "wf-admin-cloudinfo-${var.wayfinder_instance_id}"
  tags                = var.tags
}

resource "azurerm_role_definition" "wayfinder_cloud_info" {
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
  depends_on           = [time_sleep.after_azurerm_role_definition]
  scope                = data.azurerm_subscription.current.id
  role_definition_name = azurerm_role_definition.wayfinder_cloud_info.name
  principal_id         = azurerm_user_assigned_identity.wayfinder_cloud_info.principal_id
}

resource "azurerm_user_assigned_identity" "wayfinder_none" {
  location            = var.location
  resource_group_name = module.aks.node_resource_group
  name                = "wf-admin-none-${var.wayfinder_instance_id}"
  tags                = var.tags
}

resource "azurerm_role_definition" "wayfinder_none" {
  name        = "WayfinderNone-${var.wayfinder_instance_id}"
  scope       = data.azurerm_subscription.current.id
  description = "Wayfinder managed access to access subscription and tenant info"

  permissions {
    actions = [
      "Microsoft.Resources/subscriptions/providers/read"
    ]
    not_actions = []
  }
}

resource "azurerm_role_assignment" "wayfinder_none" {
  depends_on           = [time_sleep.after_azurerm_role_definition]
  scope                = data.azurerm_subscription.current.id
  role_definition_name = azurerm_role_definition.wayfinder_none.name
  principal_id         = azurerm_user_assigned_identity.wayfinder_none.principal_id
}

resource "azurerm_user_assigned_identity" "wayfinder_main" {
  location            = var.location
  resource_group_name = module.aks.node_resource_group
  name                = "wf-admin-main-${var.wayfinder_instance_id}"
  tags                = var.tags
}

resource "azurerm_role_definition" "wayfinder_main" {
  name        = "WayfinderMain-${var.wayfinder_instance_id}"
  scope       = data.azurerm_subscription.current.id
  description = "Minimal Wayfinder permissions"

  permissions {
    actions = [
      "Microsoft.Resources/subscriptions/resources/read"
    ]
    not_actions = []
  }
}

resource "azurerm_role_assignment" "wayfinder_main" {
  depends_on           = [time_sleep.after_azurerm_role_definition]
  scope                = data.azurerm_subscription.current.id
  role_definition_name = azurerm_role_definition.wayfinder_main.name
  principal_id         = azurerm_user_assigned_identity.wayfinder_main.principal_id
}

resource "kubectl_manifest" "wayfinder_namespace" {
  count = var.enable_k8s_resources ? 1 : 0

  depends_on = [
    module.aks,
  ]

  yaml_body = templatefile("${path.module}/manifests/namespace.yml.tpl", {
    namespace = "wayfinder"
  })
}

resource "kubectl_manifest" "wayfinder_azure_identity_dns_zone_manager" {
  count = var.enable_k8s_resources ? 1 : 0

  depends_on = [
    helm_release.aad_pod_identity,
    kubectl_manifest.wayfinder_namespace,
  ]

  yaml_body = templatefile("${path.module}/manifests/wayfinder-azure-identity.yml.tpl", {
    name        = azurerm_user_assigned_identity.wayfinder_dns_zone_manager.name
    resource_id = azurerm_user_assigned_identity.wayfinder_dns_zone_manager.id
    client_id   = azurerm_user_assigned_identity.wayfinder_dns_zone_manager.client_id
  })
}

resource "kubectl_manifest" "wayfinder_azure_identity_binding_dns_zone_manager" {
  count = var.enable_k8s_resources ? 1 : 0

  depends_on = [
    kubectl_manifest.wayfinder_azure_identity_dns_zone_manager,
  ]

  yaml_body = templatefile("${path.module}/manifests/wayfinder-azure-identity-binding.yml.tpl", {
    azure_identity = azurerm_user_assigned_identity.wayfinder_dns_zone_manager.name
  })
}

resource "kubectl_manifest" "wayfinder_azure_identity_cloud_info" {
  count = var.enable_k8s_resources ? 1 : 0

  depends_on = [
    helm_release.aad_pod_identity,
    kubectl_manifest.wayfinder_namespace,
  ]

  yaml_body = templatefile("${path.module}/manifests/wayfinder-azure-identity.yml.tpl", {
    name        = azurerm_user_assigned_identity.wayfinder_cloud_info.name
    resource_id = azurerm_user_assigned_identity.wayfinder_cloud_info.id
    client_id   = azurerm_user_assigned_identity.wayfinder_cloud_info.client_id
  })
}

resource "kubectl_manifest" "wayfinder_azure_identity_binding_cloud_info" {
  count = var.enable_k8s_resources ? 1 : 0

  depends_on = [
    kubectl_manifest.wayfinder_azure_identity_cloud_info,
  ]

  yaml_body = templatefile("${path.module}/manifests/wayfinder-azure-identity-binding.yml.tpl", {
    azure_identity = azurerm_user_assigned_identity.wayfinder_cloud_info.name
  })
}

resource "kubectl_manifest" "wayfinder_azure_identity_none" {
  count = var.enable_k8s_resources ? 1 : 0

  depends_on = [
    helm_release.aad_pod_identity,
    kubectl_manifest.wayfinder_namespace,
  ]

  yaml_body = templatefile("${path.module}/manifests/wayfinder-azure-identity.yml.tpl", {
    name        = azurerm_user_assigned_identity.wayfinder_none.name
    resource_id = azurerm_user_assigned_identity.wayfinder_none.id
    client_id   = azurerm_user_assigned_identity.wayfinder_none.client_id
  })
}

resource "kubectl_manifest" "wayfinder_azure_identity_binding_none" {
  count = var.enable_k8s_resources ? 1 : 0

  depends_on = [
    kubectl_manifest.wayfinder_azure_identity_none,
  ]

  yaml_body = templatefile("${path.module}/manifests/wayfinder-azure-identity-binding.yml.tpl", {
    azure_identity = azurerm_user_assigned_identity.wayfinder_none.name
  })
}

resource "kubectl_manifest" "wayfinder_azure_identity_main" {
  count = var.enable_k8s_resources ? 1 : 0

  depends_on = [
    helm_release.aad_pod_identity,
    kubectl_manifest.wayfinder_namespace,
  ]

  yaml_body = templatefile("${path.module}/manifests/wayfinder-azure-identity.yml.tpl", {
    name        = azurerm_user_assigned_identity.wayfinder_main.name
    resource_id = azurerm_user_assigned_identity.wayfinder_main.id
    client_id   = azurerm_user_assigned_identity.wayfinder_main.client_id
  })
}

resource "kubectl_manifest" "wayfinder_azure_identity_binding_main" {
  count = var.enable_k8s_resources ? 1 : 0

  depends_on = [
    kubectl_manifest.wayfinder_azure_identity_main,
  ]

  yaml_body = templatefile("${path.module}/manifests/wayfinder-azure-identity-binding.yml.tpl", {
    azure_identity = azurerm_user_assigned_identity.wayfinder_main.name
  })
}

resource "kubectl_manifest" "wayfinder_azure_admin_cloudaccessconfig" {
  count      = var.enable_k8s_resources ? 1 : 0
  depends_on = [time_sleep.after_kubectl_manifest_cloud_identity]

  yaml_body = templatefile("${path.module}/manifests/wayfinder-azure-admin-cloudaccessconfig.yml.tpl", {
    region                    = var.location
    subscription_id           = data.azurerm_subscription.current.subscription_id
    dns_zone_manager_identity = azurerm_user_assigned_identity.wayfinder_dns_zone_manager.name
    cloud_info_identity       = azurerm_user_assigned_identity.wayfinder_cloud_info.name
    none_identity             = azurerm_user_assigned_identity.wayfinder_none.name
  })
}
