# Example: Complete (includes pre-configured Wayfinder SSO)

## Deployment

1. Create a Resource Group for Wayfinder to be installed within.
2. Create a DNS Zone in Azure and ensure the domain is delegated to the Azure DNS nameservers.
3. Copy the `terraform.tfvars.example` file to `terraform.tfvars` and update with your values.
4. Run `terraform init -upgrade`
5. Run `terraform apply`

## Updating Docs

The `terraform-docs` utility is used to generate this README. Follow the below steps to update:

1. Make changes to the `.terraform-docs.yml` file
2. Fetch the `terraform-docs` binary (https://terraform-docs.io/user-guide/installation/)
3. Run `terraform-docs markdown table --output-file ${PWD}/README.md --output-mode inject .`

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | >= 1.8.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.84 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.9.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | ~> 2.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.23.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.5 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~> 0.9.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.116.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.3 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.6 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_wayfinder"></a> [wayfinder](#module\_wayfinder) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault.kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_certificate.root](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_certificate) | resource |
| [azurerm_key_vault_certificate.signing](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_certificate) | resource |
| [azurerm_private_endpoint.kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_role_assignment.kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.private_dns](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_subnet.aks_nodes](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_user_assigned_identity.aks_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_virtual_network.wayfinder](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [random_id.kv](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [tls_cert_request.signing](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/cert_request) | resource |
| [tls_locally_signed_cert.signing](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/locally_signed_cert) | resource |
| [tls_private_key.root](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_private_key.signing](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_self_signed_cert.root](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_dns_zone.wayfinder](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/dns_zone) | data source |
| [azurerm_private_dns_zone.wayfinder](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_api_server_authorized_ip_ranges"></a> [aks\_api\_server\_authorized\_ip\_ranges](#input\_aks\_api\_server\_authorized\_ip\_ranges) | The list of authorized IP ranges to contact the Wayfinder Management AKS Cluster API server. | `list(string)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> | no |
| <a name="input_aks_rbac_aad_admin_groups"></a> [aks\_rbac\_aad\_admin\_groups](#input\_aks\_rbac\_aad\_admin\_groups) | Map of Azure AD Groups and their Object IDs that will be set as cluster admin. | `map(string)` | n/a | yes |
| <a name="input_aks_vnet_subnet_id"></a> [aks\_vnet\_subnet\_id](#input\_aks\_vnet\_subnet\_id) | The ID of the subnet in which to deploy the Kubernetes Cluster. | `string` | `null` | no |
| <a name="input_ca_org_name"></a> [ca\_org\_name](#input\_ca\_org\_name) | The organisation name to use for the CA. Required if using keyvault cluster issuer. | `string` | `null` | no |
| <a name="input_cert_manager_keyvault_cert_name"></a> [cert\_manager\_keyvault\_cert\_name](#input\_cert\_manager\_keyvault\_cert\_name) | Keyvault certificate name to use for cert-manager. | `string` | `null` | no |
| <a name="input_cert_manager_keyvault_name"></a> [cert\_manager\_keyvault\_name](#input\_cert\_manager\_keyvault\_name) | Keyvault name to use for cert-manager. | `string` | `null` | no |
| <a name="input_clusterissuer"></a> [clusterissuer](#input\_clusterissuer) | Cluster Issuer name to use for certs | `string` | `"letsencrypt-prod"` | no |
| <a name="input_clusterissuer_email"></a> [clusterissuer\_email](#input\_clusterissuer\_email) | The email address to use for the cert-manager cluster issuer. | `string` | n/a | yes |
| <a name="input_create_localadmin_user"></a> [create\_localadmin\_user](#input\_create\_localadmin\_user) | Whether to create a localadmin user for access to the Wayfinder Portal and API. | `bool` | `false` | no |
| <a name="input_disable_internet_access"></a> [disable\_internet\_access](#input\_disable\_internet\_access) | Whether to disable internet access for AKS and the Wayfinder ingress controller. | `bool` | `false` | no |
| <a name="input_disable_local_login"></a> [disable\_local\_login](#input\_disable\_local\_login) | Whether to disable local login for Wayfinder. Note: An IDP must be configured within Wayfinder, otherwise you will not be able to log in. | `bool` | `false` | no |
| <a name="input_dns_provider"></a> [dns\_provider](#input\_dns\_provider) | DNS provider for External DNS | `string` | `"azure"` | no |
| <a name="input_dns_resource_group_name"></a> [dns\_resource\_group\_name](#input\_dns\_resource\_group\_name) | The name of the resource group where the DNS Zone exists. | `string` | n/a | yes |
| <a name="input_dns_zone_name"></a> [dns\_zone\_name](#input\_dns\_zone\_name) | The name of the DNS zone to use for wayfinder. | `string` | n/a | yes |
| <a name="input_enable_k8s_resources"></a> [enable\_k8s\_resources](#input\_enable\_k8s\_resources) | Whether to enable the creation of Kubernetes resources for Wayfinder (helm and kubectl manifest deployments). | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment in which the resources are deployed. | `string` | `"production"` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region in which to create the resources. | `string` | `"uksouth"` | no |
| <a name="input_private_dns_zone_id"></a> [private\_dns\_zone\_id](#input\_private\_dns\_zone\_id) | Private DNS zone to use for private clusters | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the AKS cluster. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_user_assigned_identity"></a> [user\_assigned\_identity](#input\_user\_assigned\_identity) | MSI id for AKS to run as | `string` | `null` | no |
| <a name="input_venafi_apikey"></a> [venafi\_apikey](#input\_venafi\_apikey) | Venafi API key - required if using Venafi cluster issuer | `string` | `""` | no |
| <a name="input_venafi_zone"></a> [venafi\_zone](#input\_venafi\_zone) | Venafi zone - required if using Venafi cluster issuer | `string` | `""` | no |
| <a name="input_wayfinder_idp_details"></a> [wayfinder\_idp\_details](#input\_wayfinder\_idp\_details) | The IDP details to use for Wayfinder to enable SSO. | <pre>object({<br/>    type          = string<br/>    clientId      = string<br/>    clientSecret  = string<br/>    serverUrl     = optional(string)<br/>    azureTenantId = optional(string)<br/>  })</pre> | n/a | yes |
| <a name="input_wayfinder_instance_id"></a> [wayfinder\_instance\_id](#input\_wayfinder\_instance\_id) | The instance ID to use for Wayfinder. | `string` | n/a | yes |
| <a name="input_wayfinder_licence_key"></a> [wayfinder\_licence\_key](#input\_wayfinder\_licence\_key) | The licence key to use for Wayfinder. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the Wayfinder AKS cluster |
| <a name="output_wayfinder_api_url"></a> [wayfinder\_api\_url](#output\_wayfinder\_api\_url) | The URL for the Wayfinder API |
| <a name="output_wayfinder_instance_id"></a> [wayfinder\_instance\_id](#output\_wayfinder\_instance\_id) | The unique identifier for the Wayfinder instance |
| <a name="output_wayfinder_ui_url"></a> [wayfinder\_ui\_url](#output\_wayfinder\_ui\_url) | The URL for the Wayfinder UI |
<!-- END_TF_DOCS -->

