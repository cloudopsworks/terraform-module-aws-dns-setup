## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resolver_endpoint_in"></a> [resolver\_endpoint\_in](#module\_resolver\_endpoint\_in) | terraform-aws-modules/route53/aws//modules/resolver-endpoints | ~> 3.0 |
| <a name="module_resolver_endpoint_out"></a> [resolver\_endpoint\_out](#module\_resolver\_endpoint\_out) | terraform-aws-modules/route53/aws//modules/resolver-endpoints | ~> 3.0 |
| <a name="module_tags"></a> [tags](#module\_tags) | cloudopsworks/tags/local | 1.0.9 |

## Resources

| Name | Type |
|------|------|
| [aws_ram_principal_association.custom_inbound_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_principal_association) | resource |
| [aws_ram_principal_association.inbound_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_principal_association) | resource |
| [aws_ram_resource_association.custom_inbound_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_association) | resource |
| [aws_ram_resource_association.inbound_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_association) | resource |
| [aws_ram_resource_share.custom_inbound_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_share) | resource |
| [aws_ram_resource_share.inbound_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_share) | resource |
| [aws_ram_resource_share_accepter.inbound_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_share_accepter) | resource |
| [aws_route53_resolver_rule.custom_inbound_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_rule) | resource |
| [aws_route53_resolver_rule.inbound_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_rule) | resource |
| [aws_route53_resolver_rule_association.custom_inbound_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_rule_association) | resource |
| [aws_route53_resolver_rule_association.inbound_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_rule_association) | resource |
| [aws_route53_vpc_association_authorization.vpc_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_vpc_association_authorization) | resource |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_route53_zone_association.vpc_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone_association) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_association_zone_ids"></a> [association\_zone\_ids](#input\_association\_zone\_ids) | List of Route53 zone IDs to associate with the DNS resolver. This is used to link the resolver with specific zones for DNS resolution. | `set(string)` | `[]` | no |
| <a name="input_custom_resolver_rules"></a> [custom\_resolver\_rules](#input\_custom\_resolver\_rules) | Map of custom resolver rules to create. Each key is the rule name, and the value is an object with the following attributes: domain\_name, rule\_type (FORWARD or SYSTEM), addresses (optional list of IP addresses), associate\_vpc (boolean). | `any` | `{}` | no |
| <a name="input_dns_vpc"></a> [dns\_vpc](#input\_dns\_vpc) | VPC configuration for DNS resolver. This is used to specify the VPC ID and region where the DNS resolver will be created. | <pre>object({<br/>    vpc_id     = optional(string, "")<br/>    vpc_region = optional(string, "us-east-1")<br/>  })</pre> | <pre>{<br/>  "vpc_id": "",<br/>  "vpc_region": ""<br/>}</pre> | no |
| <a name="input_enable_auto_accept"></a> [enable\_auto\_accept](#input\_enable\_auto\_accept) | Enable automatic acceptance of RAM shares for the DNS resolver. This is useful when sharing the resolver with other accounts. | `bool` | `true` | no |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | Extra tags to add to the resources | `map(string)` | `{}` | no |
| <a name="input_is_hub"></a> [is\_hub](#input\_is\_hub) | Is this a hub or spoke configuration? | `bool` | `false` | no |
| <a name="input_max_resolver_enis"></a> [max\_resolver\_enis](#input\_max\_resolver\_enis) | Maximum number of resolver ENIs to create. Set to -1 for all available ENIs, or a specific number greater than or equal to 2. | `number` | `-1` | no |
| <a name="input_org"></a> [org](#input\_org) | Organization details | <pre>object({<br/>    organization_name = string<br/>    organization_unit = string<br/>    environment_type  = string<br/>    environment_name  = string<br/>  })</pre> | n/a | yes |
| <a name="input_ram"></a> [ram](#input\_ram) | Resource Access Manager (RAM) configuration for sharing the DNS resolver across accounts. This includes whether to enable sharing, allow external principals, and a list of principals to share with. | <pre>object({<br/>    enabled                   = optional(bool, true)<br/>    allow_external_principals = optional(bool, false)<br/>    principals                = optional(list(string), [])<br/>  })</pre> | <pre>{<br/>  "allow_external_principals": false,<br/>  "enabled": false,<br/>  "principals": []<br/>}</pre> | no |
| <a name="input_shared"></a> [shared](#input\_shared) | Shared configuration for the DNS resolver, including RAM shares and resolver rules. This is used to define how the resolver will be shared across accounts and any custom resolver rules. | <pre>object({<br/>    ram_shares     = any<br/>    resolver_rules = any<br/>  })</pre> | <pre>{<br/>  "ram_shares": {},<br/>  "resolver_rules": {}<br/>}</pre> | no |
| <a name="input_spoke_def"></a> [spoke\_def](#input\_spoke\_def) | Spoke ID Number, must be a 3 digit number | `string` | `"001"` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs where the DNS resolver will be deployed. This is required for creating the resolver endpoints. | `list(string)` | `[]` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | CIDR block for the VPC. This is required for private zones. | `string` | `""` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID to associate with the Route53 zones. This is required for private zones. | `string` | `""` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | Map of Route53 zones to create. Each key is the zone name, and the value is an object with the following attributes: domain\_name, comment, private (boolean), force\_destroy (boolean), delegation\_set\_id (optional), tags (optional). | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_custom_resolver_rules"></a> [custom\_resolver\_rules](#output\_custom\_resolver\_rules) | n/a |
| <a name="output_dns_vpc"></a> [dns\_vpc](#output\_dns\_vpc) | n/a |
| <a name="output_ram"></a> [ram](#output\_ram) | n/a |
| <a name="output_resolver_endpoints"></a> [resolver\_endpoints](#output\_resolver\_endpoints) | n/a |
| <a name="output_resolver_rules"></a> [resolver\_rules](#output\_resolver\_rules) | n/a |
| <a name="output_resolver_rules_associations"></a> [resolver\_rules\_associations](#output\_resolver\_rules\_associations) | n/a |
| <a name="output_vpc_association_auth"></a> [vpc\_association\_auth](#output\_vpc\_association\_auth) | n/a |
| <a name="output_zones"></a> [zones](#output\_zones) | n/a |
