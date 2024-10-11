<!-- BEGIN_TF_DOCS -->
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