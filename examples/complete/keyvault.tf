resource "random_id" "kv" {
  byte_length = 2
}

resource "azurerm_key_vault" "kv" {
  count                       = var.clusterissuer == "keyvault" && var.cert_manager_keyvault_name == null ? 1 : 0
  location                    = var.location
  name                        = format("kv-wayfinder-ca-%s", random_id.kv.hex)
  resource_group_name         = var.resource_group_name
  sku_name                    = "premium"
  tenant_id                   = data.azurerm_subscription.current.tenant_id
  purge_protection_enabled    = true
  enable_rbac_authorization   = true
  
  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "kv" {
  count               = var.clusterissuer == "keyvault" && var.cert_manager_keyvault_name == null ? 1 : 0
  name                = "pend-${azurerm_key_vault.kv[0].name}"
  location            = azurerm_key_vault.kv[0].location
  resource_group_name = azurerm_key_vault.kv[0].resource_group_name
  subnet_id           = var.aks_vnet_subnet_id

  private_service_connection {
    name                           = azurerm_key_vault.kv[0].name
    private_connection_resource_id = azurerm_key_vault.kv[0].id
    is_manual_connection           = false

    subresource_names = ["vault"]
  }

  private_dns_zone_group {
    name                           = azurerm_key_vault.kv[0].name
    private_dns_zone_ids            = [replace(var.private_dns_zone_id, "/[^\\/]*$/", "privatelink.vaultcore.azure.net")]
  }

  tags = var.tags
}

resource "tls_private_key" "root" {
  count     = var.clusterissuer == "keyvault" && var.cert_manager_keyvault_name == null ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "root" {
  count           = var.clusterissuer == "keyvault" && var.cert_manager_keyvault_name == null ? 1 : 0
  private_key_pem = tls_private_key.root[0].private_key_pem

  subject {
    common_name  = "${var.ca_org_name} Root CA"
    organization = var.ca_org_name
  }

  validity_period_hours = (5 * 365 * 24) # 5 years

  allowed_uses = [
    "digital_signature",
    "cert_signing",
    "crl_signing"
  ]
}

resource "azurerm_key_vault_certificate" "root" {
  count        = var.clusterissuer == "keyvault" && var.cert_manager_keyvault_name == null ? 1 : 0
  name         = "root-ca"
  key_vault_id = azurerm_key_vault.kv[0].id

  certificate {
    contents = "${tls_self_signed_cert.root[0].cert_pem}\n${tls_private_key.root[0].private_key_pem}"
  }
}

resource "tls_private_key" "signing" {
  count     = var.clusterissuer == "keyvault" && var.cert_manager_keyvault_name == null ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_cert_request" "signing" {
  count           = var.clusterissuer == "keyvault" && var.cert_manager_keyvault_name == null ? 1 : 0
  private_key_pem = tls_private_key.signing[0].private_key_pem

  subject {
    common_name  = "${var.ca_org_name} Signing CA"
    organization = var.ca_org_name
  }
}

resource "tls_locally_signed_cert" "signing" {
  count              = var.clusterissuer == "keyvault" && var.cert_manager_keyvault_name == null ? 1 : 0
  cert_request_pem   = tls_cert_request.signing[0].cert_request_pem
  ca_private_key_pem = tls_private_key.root[0].private_key_pem
  ca_cert_pem        = tls_self_signed_cert.root[0].cert_pem

  validity_period_hours = (2 * 365 * 24) # 2 years

  allowed_uses = [
    "digital_signature",
    "cert_signing",
    "crl_signing"
  ]
}

resource "azurerm_key_vault_certificate" "signing" {
  count        = var.clusterissuer == "keyvault" && var.cert_manager_keyvault_name == null ? 1 : 0
  name         = "signing-ca"
  key_vault_id = azurerm_key_vault.kv[0].id

  certificate {
    contents = "${tls_locally_signed_cert.signing[0].cert_pem}\n${tls_private_key.signing[0].private_key_pem}"
  }
}