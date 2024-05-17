<!-- BEGIN_TF_DOCS -->
# Terraform Module: Wayfinder on Azure

The "terraform-azurerm-wayfinder" Terraform Module can be used to provision and manage a licensed edition of [Appvia Wayfinder](https://www.appvia.io/product/) on Azure.

## Requirements

To run this module, you will need the following:
1. Product Licence Key & Instance ID: Contact sales@appvia.io for more information.
2. (Optional) IDP App configuration details: Wayfinder integrates with an IDP for managing user access. You will need a valid Client ID, Client Secret and Server URL (or Azure Tenant ID) for setup. This does not need to be defined initially within Terraform, and can also be setup within the product. Wayfinder can provision a `localadmin` user for initial access if no IDP details are provided.
3. A public Azure DNS Zone: This module will create DNS records for the Wayfinder API and UI endpoints, and performs a DNS01 challenge via the LetsEncrypt Issuer for valid domain certificates.
4. Existing Virtual Network and Subnet: This module will deploy an AKS Cluster and so requires an existing vnet with outbound internet connectivity.

## Deployment

Please see the [examples](./examples) directory to see how to deploy this module. To get up and running quickly with minimal pre-requisites, use the [quickstart](./examples/quickstart) example.

### (Optional) Connecting to an Identity Provider

Wayfinder integrates with an IDP for managing user access. You will need a valid Client ID, Client Secret and Server URL (or Azure Tenant ID).

This configuration is optional within Terraform, and can also be setup within the product. Please view the documentation for more information: https://docs.appvia.io/wayfinder/admin/auth

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

## Updating Docs

The `terraform-docs` utility is used to generate this README. Follow the below steps to update:
1. Make changes to the `.terraform-docs.yml` file
2. Fetch the `terraform-docs` binary (https://terraform-docs.io/user-guide/installation/)
3. Run `terraform-docs markdown table --output-file ${PWD}/README.md --output-mode inject .`

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_adcs"></a> [adcs](#input\_adcs) | ADCS variables required when using ADCS Issuer with Cert Manager | <pre>object({<br>    url                       = string<br>    username                  = string<br>    ca_bundle                 = string<br>    certificate_template_name = string<br>  })</pre> | `null` | no |
| <a name="input_adcs_password"></a> [adcs\_password](#input\_adcs\_password) | ADCS password required when using ADCS Issuer with Cert Manager | `string` | `""` | no |
| <a name="input_aks_agents_size"></a> [aks\_agents\_size](#input\_aks\_agents\_size) | The default size of the agents pool. | `string` | `"Standard_D2s_v3"` | no |
| <a name="input_aks_api_server_authorized_ip_ranges"></a> [aks\_api\_server\_authorized\_ip\_ranges](#input\_aks\_api\_server\_authorized\_ip\_ranges) | The list of authorized IP ranges to contact the API server. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_aks_enable_host_encryption"></a> [aks\_enable\_host\_encryption](#input\_aks\_enable\_host\_encryption) | Whether to enable host encryption. | `bool` | `false` | no |
| <a name="input_aks_maintenance_window"></a> [aks\_maintenance\_window](#input\_aks\_maintenance\_window) | Maintenance configuration of the managed cluster. | <pre>object({<br>    allowed = list(object({<br>      day   = string<br>      hours = set(number)<br>    })),<br>    not_allowed = list(object({<br>      end   = string<br>      start = string<br>    })),<br>  })</pre> | <pre>{<br>  "allowed": [<br>    {<br>      "day": "Sunday",<br>      "hours": [<br>        22,<br>        23<br>      ]<br>    }<br>  ],<br>  "not_allowed": []<br>}</pre> | no |
| <a name="input_aks_rbac_aad_admin_group_object_ids"></a> [aks\_rbac\_aad\_admin\_group\_object\_ids](#input\_aks\_rbac\_aad\_admin\_group\_object\_ids) | List of object IDs of the Azure AD groups that will be set as cluster admin. | `list(string)` | `[]` | no |
| <a name="input_aks_sku_tier"></a> [aks\_sku\_tier](#input\_aks\_sku\_tier) | The SKU tier for this Kubernetes Cluster. | `string` | `"Standard"` | no |
| <a name="input_aks_vnet_subnet_id"></a> [aks\_vnet\_subnet\_id](#input\_aks\_vnet\_subnet\_id) | The ID of the subnet in which to deploy the Kubernetes Cluster. | `string` | n/a | yes |
| <a name="input_cert_manager_keyvault_cert_name"></a> [cert\_manager\_keyvault\_cert\_name](#input\_cert\_manager\_keyvault\_cert\_name) | Keyvault certificate name to use for cert-manager. Required if cluster issuer is keyvault | `string` | `null` | no |
| <a name="input_cert_manager_keyvault_name"></a> [cert\_manager\_keyvault\_name](#input\_cert\_manager\_keyvault\_name) | Keyvault name to use for cert-manager. Required if cluster issuer is keyvault | `string` | `null` | no |
| <a name="input_cluster_nodepool_version"></a> [cluster\_nodepool\_version](#input\_cluster\_nodepool\_version) | The Kubernetes version to use for the AKS cluster Nodepools. | `string` | `"1.28"` | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | The Kubernetes version to use for the AKS cluster. | `string` | `"1.29"` | no |
| <a name="input_clusterissuer"></a> [clusterissuer](#input\_clusterissuer) | Cluster Issuer name to use for certs | `string` | `"letsencrypt-prod"` | no |
| <a name="input_clusterissuer_email"></a> [clusterissuer\_email](#input\_clusterissuer\_email) | The email address to use for the cert-manager cluster issuer. | `string` | n/a | yes |
| <a name="input_create_duration_delay"></a> [create\_duration\_delay](#input\_create\_duration\_delay) | Used to tune terraform apply when faced with errors caused by API caching or eventual consistency. Sets a custom delay period after creation of the specified resource type. | <pre>object({<br>    azurerm_role_definition         = optional(string, "180s")<br>    kubectl_manifest_cloud_identity = optional(string, "30s")<br>  })</pre> | `{}` | no |
| <a name="input_create_localadmin_user"></a> [create\_localadmin\_user](#input\_create\_localadmin\_user) | Whether to create a localadmin user for access to the Wayfinder Portal and API | `bool` | `true` | no |
| <a name="input_destroy_duration_delay"></a> [destroy\_duration\_delay](#input\_destroy\_duration\_delay) | Used to tune terraform destroy when faced with errors caused by API caching or eventual consistency. Sets a custom delay period after destruction of the specified resource type. | <pre>object({<br>    azurerm_role_definition         = optional(string, "0s")<br>    kubectl_manifest_cloud_identity = optional(string, "60s")<br>  })</pre> | `{}` | no |
| <a name="input_disable_internet_access"></a> [disable\_internet\_access](#input\_disable\_internet\_access) | Whether to disable internet access for AKS and the Wayfinder ingress controller | `bool` | `false` | no |
| <a name="input_disable_local_login"></a> [disable\_local\_login](#input\_disable\_local\_login) | Whether to disable local login for Wayfinder. Note: An IDP must be configured within Wayfinder, otherwise you will not be able to log in. | `bool` | `false` | no |
| <a name="input_dns_provider"></a> [dns\_provider](#input\_dns\_provider) | DNS provider for External DNS | `string` | `"azure"` | no |
| <a name="input_dns_resource_group_id"></a> [dns\_resource\_group\_id](#input\_dns\_resource\_group\_id) | The ID of the resource group where the DNS Zone exists, if different to Wayfinder's resource group. | `string` | `""` | no |
| <a name="input_dns_zone_id"></a> [dns\_zone\_id](#input\_dns\_zone\_id) | The ID of the Azure DNS Zone to use. | `string` | n/a | yes |
| <a name="input_dns_zone_name"></a> [dns\_zone\_name](#input\_dns\_zone\_name) | The name of the Azure DNS zone to use. | `string` | n/a | yes |
| <a name="input_enable_k8s_resources"></a> [enable\_k8s\_resources](#input\_enable\_k8s\_resources) | Whether to enable the creation of Kubernetes resources for Wayfinder (helm and kubectl manifest deployments) | `bool` | `true` | no |
| <a name="input_enable_wf_cloudaccess"></a> [enable\_wf\_cloudaccess](#input\_enable\_wf\_cloudaccess) | Whether to configure CloudIdentity and admin CloudAccessConfig resources in Wayfinder once installed (requires enable\_k8s\_resources) | `bool` | `true` | no |
| <a name="input_enable_wf_costestimates"></a> [enable\_wf\_costestimates](#input\_enable\_wf\_costestimates) | Whether to configure admin CloudAccessConfig for cost estimates in the account Wayfinder is installed in once installed (requires enable\_k8s\_resources and enable\_wf\_cloudaccess) | `bool` | `true` | no |
| <a name="input_enable_wf_dnszonemanager"></a> [enable\_wf\_dnszonemanager](#input\_enable\_wf\_dnszonemanager) | Whether to configure admin CloudAccessConfig for DNS zone management in the account Wayfinder is installed in once installed (requires enable\_k8s\_resources and enable\_wf\_cloudaccess) | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment in which the resources are deployed. | `string` | `"production"` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region to use. | `string` | `"uksouth"` | no |
| <a name="input_private_dns_zone_id"></a> [private\_dns\_zone\_id](#input\_private\_dns\_zone\_id) | Private DNS zone to use for private clusters | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the AKS cluster. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to resources. | `map(string)` | `{}` | no |
| <a name="input_user_assigned_identity"></a> [user\_assigned\_identity](#input\_user\_assigned\_identity) | MSI id for AKS to run as | `string` | n/a | yes |
| <a name="input_venafi_apikey"></a> [venafi\_apikey](#input\_venafi\_apikey) | Venafi API key - required if using Venafi cluster issuer | `string` | `""` | no |
| <a name="input_venafi_zone"></a> [venafi\_zone](#input\_venafi\_zone) | Venafi zone - required if using Venafi cluster issuer | `string` | `""` | no |
| <a name="input_wayfinder_domain_name_api"></a> [wayfinder\_domain\_name\_api](#input\_wayfinder\_domain\_name\_api) | The domain name to use for the Wayfinder API (e.g. api.wayfinder.example.com) | `string` | n/a | yes |
| <a name="input_wayfinder_domain_name_ui"></a> [wayfinder\_domain\_name\_ui](#input\_wayfinder\_domain\_name\_ui) | The domain name to use for the Wayfinder UI (e.g. portal.wayfinder.example.com) | `string` | n/a | yes |
| <a name="input_wayfinder_idp_details"></a> [wayfinder\_idp\_details](#input\_wayfinder\_idp\_details) | The IDP details to use for Wayfinder to enable SSO | <pre>object({<br>    type          = string<br>    clientId      = optional(string)<br>    clientSecret  = optional(string)<br>    serverUrl     = optional(string)<br>    azureTenantId = optional(string)<br>  })</pre> | <pre>{<br>  "azureTenantId": "",<br>  "clientId": null,<br>  "clientSecret": null,<br>  "serverUrl": "",<br>  "type": "none"<br>}</pre> | no |
| <a name="input_wayfinder_instance_id"></a> [wayfinder\_instance\_id](#input\_wayfinder\_instance\_id) | The instance ID to use for Wayfinder. | `string` | n/a | yes |
| <a name="input_wayfinder_licence_key"></a> [wayfinder\_licence\_key](#input\_wayfinder\_licence\_key) | The licence key to use for Wayfinder | `string` | n/a | yes |
| <a name="input_wayfinder_release_channel"></a> [wayfinder\_release\_channel](#input\_wayfinder\_release\_channel) | The release channel to use for Wayfinder | `string` | `"wayfinder-releases"` | no |
| <a name="input_wayfinder_version"></a> [wayfinder\_version](#input\_wayfinder\_version) | The version to use for Wayfinder | `string` | `"v2.7.0"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aks_admin_host"></a> [aks\_admin\_host](#output\_aks\_admin\_host) | The API URL of the Azure Kubernetes Managed Cluster. |
| <a name="output_aks_client_certificate"></a> [aks\_client\_certificate](#output\_aks\_client\_certificate) | The `client_certificate` in the `azurerm_kubernetes_cluster`'s `kube_admin_config` block.  Base64 encoded public certificate used by clients to authenticate to the Kubernetes cluster. |
| <a name="output_aks_client_key"></a> [aks\_client\_key](#output\_aks\_client\_key) | The `client_key` in the `azurerm_kubernetes_cluster`'s `kube_admin_config` block. Base64 encoded private key used by clients to authenticate to the Kubernetes cluster. |
| <a name="output_aks_cluster_ca_certificate"></a> [aks\_cluster\_ca\_certificate](#output\_aks\_cluster\_ca\_certificate) | The `cluster_ca_certificate` in the `azurerm_kubernetes_cluster`'s `kube_admin_config` block. Base64 encoded public CA certificate used as the root of trust for the Kubernetes cluster. |
| <a name="output_aks_kubeconfig_host"></a> [aks\_kubeconfig\_host](#output\_aks\_kubeconfig\_host) | The Kubernetes cluster server host. This is a Private Link address if 'disable\_internet\_access' is configured. |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the Wayfinder AKS cluster. |
| <a name="output_wayfinder_admin_password"></a> [wayfinder\_admin\_password](#output\_wayfinder\_admin\_password) | The password for the Wayfinder local admin user. |
| <a name="output_wayfinder_admin_username"></a> [wayfinder\_admin\_username](#output\_wayfinder\_admin\_username) | The username for the Wayfinder local admin user. |
| <a name="output_wayfinder_api_url"></a> [wayfinder\_api\_url](#output\_wayfinder\_api\_url) | The URL for the Wayfinder API. |
| <a name="output_wayfinder_instance_id"></a> [wayfinder\_instance\_id](#output\_wayfinder\_instance\_id) | The unique identifier for the Wayfinder instance. |
| <a name="output_wayfinder_ui_url"></a> [wayfinder\_ui\_url](#output\_wayfinder\_ui\_url) | The URL for the Wayfinder UI. |
<!-- END_TF_DOCS -->