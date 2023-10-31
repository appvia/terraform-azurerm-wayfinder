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
  depends_on           = [time_sleep.after_azurerm_role_definition_main]
  scope                = data.azurerm_subscription.current.id
  role_definition_name = azurerm_role_definition.wayfinder_main.name
  principal_id         = azurerm_user_assigned_identity.wayfinder_main.principal_id
}

resource "azurerm_federated_identity_credential" "wayfinder_main" {
  name                = azurerm_user_assigned_identity.wayfinder_main.name
  resource_group_name = azurerm_user_assigned_identity.wayfinder_main.resource_group_name
  parent_id           = azurerm_user_assigned_identity.wayfinder_main.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = module.aks.oidc_issuer_url
  subject             = "system:serviceaccount:wayfinder:wayfinder-admin"
}

resource "kubectl_manifest" "wayfinder_idp" {
  count = (var.enable_k8s_resources && var.wayfinder_idp_details["type"] == "generic") ? 1 : 0

  depends_on = [
    kubectl_manifest.wayfinder_namespace,
    module.aks,
  ]

  sensitive_fields = ["stringData"]

  yaml_body = templatefile("${path.module}/manifests/wayfinder-idp.yml.tpl", {
    claims        = "preferred_username,email,name,username"
    client_id     = var.wayfinder_idp_details["clientId"]
    client_scopes = "email,profile,offline_access"
    client_secret = var.wayfinder_idp_details["clientSecret"]
    name          = "wayfinder-idp-live"
    namespace     = "wayfinder"
    server_url    = var.wayfinder_idp_details["serverUrl"]
  })
}

resource "kubectl_manifest" "wayfinder_idp_aad" {
  count = (var.enable_k8s_resources && var.wayfinder_idp_details["type"] == "aad") ? 1 : 0

  depends_on = [
    kubectl_manifest.wayfinder_namespace,
    module.aks,
  ]

  sensitive_fields = ["stringData"]

  yaml_body = templatefile("${path.module}/manifests/wayfinder-idp-aad.yml.tpl", {
    claims        = "preferred_username,email,name,username"
    client_id     = var.wayfinder_idp_details["clientId"]
    client_scopes = "email,profile,offline_access"
    client_secret = var.wayfinder_idp_details["clientSecret"]
    name          = "wayfinder-idp-live"
    namespace     = "wayfinder"
    provider      = "azure"
    tenant_id     = var.wayfinder_idp_details["azureTenantId"]
  })
}

resource "random_password" "wayfinder_localadmin" {
  count   = var.create_localadmin_user ? 1 : 0
  length  = 20
  special = false
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

resource "helm_release" "wayfinder" {
  count = var.enable_k8s_resources ? 1 : 0

  depends_on = [
    helm_release.cert_manager,
    helm_release.external_dns,
    helm_release.ingress,
    kubectl_manifest.cert_manager_clusterissuer,
    kubectl_manifest.wayfinder_idp_aad,
    kubectl_manifest.wayfinder_idp,
    kubectl_manifest.wayfinder_namespace,
    module.aks,
  ]

  name = "wayfinder"

  chart            = "https://storage.googleapis.com/${var.wayfinder_release_channel}/${var.wayfinder_version}/wayfinder-helm-chart.tgz"
  create_namespace = false
  max_history      = 5
  namespace        = "wayfinder"
  timeout          = 600
  wait             = true
  wait_for_jobs    = true

  values = [
    templatefile("${path.module}/manifests/wayfinder-values.yml.tpl", {
      api_hostname                  = var.wayfinder_domain_name_api
      clusterissuer                 = var.clusterissuer
      disable_local_login           = var.wayfinder_idp_details["type"] == "none" ? false : var.disable_local_login
      enable_localadmin_user        = var.create_localadmin_user
      storage_class                 = "managed"
      ui_hostname                   = var.wayfinder_domain_name_ui
      wayfinder_client_id           = azurerm_user_assigned_identity.wayfinder_main.client_id
      wayfinder_instance_identifier = var.wayfinder_instance_id
    })
  ]

  set_sensitive {
    name  = "licenseKey"
    value = var.wayfinder_licence_key
  }

  set_sensitive {
    name  = "localAdminPassword"
    value = var.create_localadmin_user ? random_password.wayfinder_localadmin[0].result : ""
  }
}
