locals {
  resource_prefix = "wf-"
  resource_suffix = var.resource_suffix != "" ? "-${var.resource_suffix}" : ""
}

data "azurerm_subscription" "primary" {
}
