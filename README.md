<!-- BEGIN_TF_DOCS -->
# Terraform Module: Wayfinder on Azure

The "terraform-azure-wayfinder" Terraform Module can be used to provision and manage a licensed edition of [Appvia Wayfinder](https://www.appvia.io/product/) on Azure.

## Requirements

To run this module, you will need the following:
1. Product license key: Contact sales@appvia.io for more information.
2. IDP App configuration details: Wayfinder integrates with an IDP for managing user access. You will need a valid Client ID, Client Secret and Server URL (or Azure Tenant ID) for initial configuration.
3. A public Azure DNS Zone: This module will create DNS records for the Wayfinder API and UI endpoints, and performs a DNS01 challenge via the LetsEncrypt Issuer for valid domain certificates.
4. Existing Virtual Network and Subnet: This module will deploy an AKS Cluster and so requires an existing vnet with outbound internet connectivity.

### Connecting to an Identity Provider

Wayfinder integrates with an IDP for managing user access. You will need a valid Client ID, Client Secret and Server URL (or Azure Tenant ID) for initial configuration.

The Authorized Redirect URI for the IDP Application should be set to: `https://${wayfinder_domain_name_api}/oauth/callback`

**Note:** If you are using Azure Active Directory, you must:
1. Set `azureTenantId` to your Azure Tenant ID (`serverUrl` is not required)
2. Set the IDP type to `aad`

#### Example: Generic IDP Configuration

```hcl
wayfinder_idp_details = {
  type         = "generic"
  clientId     = "IDP-APP-CLIENT-ID"
  clientSecret = "IDP-APP-CLIENT-SECRET"
  serverUrl    = "https://example.okta.com" # Or "https://example.auth0.com/"
}
```

#### Example: Azure AD IDP Configuration

```hcl
wayfinder_idp_details = {
  type          = "aad"
  clientId      = "IDP-APP-CLIENT-ID"
  clientSecret  = "IDP-APP-CLIENT-SECRET"
  azureTenantId = "12345678-1234-1234-1234-123456789012"
}
```

## Deployment

Please see the [examples](./examples) directory to see how to deploy this module.

## Updating Docs

The `terraform-docs` utility is used to generate this README. Follow the below steps to update:
1. Make changes to the `.terraform-docs.yml` file
2. Fetch the `terraform-docs` binary (https://terraform-docs.io/user-guide/installation/)
3. Run `terraform-docs markdown table --output-file ${PWD}/README.md --output-mode inject .`

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_agents_size"></a> [aks\_agents\_size](#input\_aks\_agents\_size) | The default size of the agents pool. | `string` | `"Standard_D2s_v3"` | no |
| <a name="input_aks_api_server_authorized_ip_ranges"></a> [aks\_api\_server\_authorized\_ip\_ranges](#input\_aks\_api\_server\_authorized\_ip\_ranges) | The list of authorized IP ranges to contact the API server. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_aks_enable_host_encryption"></a> [aks\_enable\_host\_encryption](#input\_aks\_enable\_host\_encryption) | Whether to enable host encryption. | `bool` | `false` | no |
| <a name="input_aks_private_cluster_enabled"></a> [aks\_private\_cluster\_enabled](#input\_aks\_private\_cluster\_enabled) | If true, the cluster API server will be exposed only on internal IP addresses. | `bool` | `false` | no |
| <a name="input_aks_private_cluster_public_fqdn_enabled"></a> [aks\_private\_cluster\_public\_fqdn\_enabled](#input\_aks\_private\_cluster\_public\_fqdn\_enabled) | Specifies whether a Public FQDN for this Private Cluster should be added. | `bool` | `false` | no |
| <a name="input_aks_public_network_access_enabled"></a> [aks\_public\_network\_access\_enabled](#input\_aks\_public\_network\_access\_enabled) | Whether public network access is allowed for this Kubernetes Cluster. | `bool` | `true` | no |
| <a name="input_aks_rbac_aad_admin_group_object_ids"></a> [aks\_rbac\_aad\_admin\_group\_object\_ids](#input\_aks\_rbac\_aad\_admin\_group\_object\_ids) | List of object IDs of the Azure AD groups that will be set as cluster admin. | `list(string)` | `[]` | no |
| <a name="input_aks_sku_tier"></a> [aks\_sku\_tier](#input\_aks\_sku\_tier) | The SKU tier for this Kubernetes Cluster. | `string` | `"Standard"` | no |
| <a name="input_aks_vnet_subnet_id"></a> [aks\_vnet\_subnet\_id](#input\_aks\_vnet\_subnet\_id) | The ID of the subnet in which to deploy the Kubernetes Cluster. | `string` | n/a | yes |
| <a name="input_clusterissuer_email"></a> [clusterissuer\_email](#input\_clusterissuer\_email) | The email address to use for the cert-manager cluster issuer. | `string` | n/a | yes |
| <a name="input_disable_internet_access"></a> [disable\_internet\_access](#input\_disable\_internet\_access) | Whether to disable internet access for AKS and the Wayfinder ingress controller | `bool` | `false` | no |
| <a name="input_dns_zone_id"></a> [dns\_zone\_id](#input\_dns\_zone\_id) | The ID of the Azure DNS Zone to use. | `string` | n/a | yes |
| <a name="input_dns_zone_name"></a> [dns\_zone\_name](#input\_dns\_zone\_name) | The name of the Azure DNS zone to use. | `string` | n/a | yes |
| <a name="input_enable_k8s_resources"></a> [enable\_k8s\_resources](#input\_enable\_k8s\_resources) | Whether to enable the creation of Kubernetes resources for Wayfinder (helm and kubectl manifest deployments) | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment in which the resources are deployed. | `string` | `"production"` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region to use. | `string` | `"uksouth"` | no |
| <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id) | The ID of the resource group in which to create the AKS cluster. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the AKS cluster. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to resources. | `map(string)` | `{}` | no |
| <a name="input_wayfinder_domain_name_api"></a> [wayfinder\_domain\_name\_api](#input\_wayfinder\_domain\_name\_api) | The domain name to use for the Wayfinder API (e.g. api.wayfinder.example.com) | `string` | n/a | yes |
| <a name="input_wayfinder_domain_name_ui"></a> [wayfinder\_domain\_name\_ui](#input\_wayfinder\_domain\_name\_ui) | The domain name to use for the Wayfinder UI (e.g. portal.wayfinder.example.com) | `string` | n/a | yes |
| <a name="input_wayfinder_idp_details"></a> [wayfinder\_idp\_details](#input\_wayfinder\_idp\_details) | The IDP details to use for Wayfinder to enable SSO | <pre>object({<br>    type          = string<br>    clientId      = string<br>    clientSecret  = string<br>    serverUrl     = optional(string)<br>    azureTenantId = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_wayfinder_instance_id"></a> [wayfinder\_instance\_id](#input\_wayfinder\_instance\_id) | The instance ID to use for Wayfinder. This can be left blank and will be autogenerated. | `string` | `""` | no |
| <a name="input_wayfinder_license_key"></a> [wayfinder\_license\_key](#input\_wayfinder\_license\_key) | The license key to use for Wayfinder | `string` | n/a | yes |
| <a name="input_wayfinder_release_channel"></a> [wayfinder\_release\_channel](#input\_wayfinder\_release\_channel) | The release channel to use for Wayfinder | `string` | `"wayfinder-releases"` | no |
| <a name="input_wayfinder_version"></a> [wayfinder\_version](#input\_wayfinder\_version) | The version to use for Wayfinder | `string` | `"v2.2.0"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aks_client_certificate"></a> [aks\_client\_certificate](#output\_aks\_client\_certificate) | The `client_certificate` in the `azurerm_kubernetes_cluster`'s `kube_admin_config` block.  Base64 encoded public certificate used by clients to authenticate to the Kubernetes cluster. |
| <a name="output_aks_client_key"></a> [aks\_client\_key](#output\_aks\_client\_key) | The `client_key` in the `azurerm_kubernetes_cluster`'s `kube_admin_config` block. Base64 encoded private key used by clients to authenticate to the Kubernetes cluster. |
| <a name="output_aks_cluster_ca_certificate"></a> [aks\_cluster\_ca\_certificate](#output\_aks\_cluster\_ca\_certificate) | The `cluster_ca_certificate` in the `azurerm_kubernetes_cluster`'s `kube_admin_config` block. Base64 encoded public CA certificate used as the root of trust for the Kubernetes cluster. |
| <a name="output_aks_host"></a> [aks\_host](#output\_aks\_host) | The `host` in the `azurerm_kubernetes_cluster`'s `kube_admin_config` block. The Kubernetes cluster server host. |
<!-- END_TF_DOCS -->