<!-- BEGIN_TF_DOCS -->
## Updating Docs

The `terraform-docs` utility is used to generate this README. Follow the below steps to update:
1. Make changes to the `.terraform-docs.yml` file
2. Fetch the `terraform-docs` binary (https://terraform-docs.io/user-guide/installation/)
3. Run `terraform-docs markdown table --output-file ${PWD}/README.md --output-mode inject .`

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_adcs_ca_bundle"></a> [adcs\_ca\_bundle](#input\_adcs\_ca\_bundle) | Base64 encoded ca bundle for communication with ADCS.  Can be obtained with 'cat bundle.pem \| base64 -w 0' | `string` | n/a | yes |
| <a name="input_adcs_url"></a> [adcs\_url](#input\_adcs\_url) | URL of the ADCS web UI | `string` | n/a | yes |
| <a name="input_certificate_template_name"></a> [certificate\_template\_name](#input\_certificate\_template\_name) | ADCS certificate template name to use for signing. | `string` | n/a | yes |
| <a name="input_password"></a> [password](#input\_password) | Password of the identity that will authenticate with ADCS to request certificates | `string` | n/a | yes |
| <a name="input_username"></a> [username](#input\_username) | Username of the identity that will authenticate with ADCS to request certificates | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->