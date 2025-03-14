<!-- 
  ** DO NOT EDIT THIS FILE
  ** 
  ** This file was automatically generated. 
  ** 1) Make all changes to `README.yaml` 
  ** 2) Run `make init` (you only need to do this once)
  ** 3) Run`make readme` to rebuild this file. 
  -->
[![README Header][readme_header_img]][readme_header_link]

[![cloudopsworks][logo]](https://cloudops.works/)

# Terraform AWS DNS Setup Module


VPC Module for setting up transit gateway with ResourceAccessMananger support.


---

This project is part of our comprehensive approach towards DevOps Acceleration. 
[<img align="right" title="Share via Email" width="24" height="24" src="https://docs.cloudops.works/images/ionicons/ios-mail.svg"/>][share_email]
[<img align="right" title="Share on Google+" width="24" height="24" src="https://docs.cloudops.works/images/ionicons/logo-googleplus.svg" />][share_googleplus]
[<img align="right" title="Share on Facebook" width="24" height="24" src="https://docs.cloudops.works/images/ionicons/logo-facebook.svg" />][share_facebook]
[<img align="right" title="Share on Reddit" width="24" height="24" src="https://docs.cloudops.works/images/ionicons/logo-reddit.svg" />][share_reddit]
[<img align="right" title="Share on LinkedIn" width="24" height="24" src="https://docs.cloudops.works/images/ionicons/logo-linkedin.svg" />][share_linkedin]
[<img align="right" title="Share on Twitter" width="24" height="24" src="https://docs.cloudops.works/images/ionicons/logo-twitter.svg" />][share_twitter]


[![Terraform Open Source Modules](https://docs.cloudops.works/images/terraform-open-source-modules.svg)][terraform_modules]



It's 100% Open Source and licensed under the [APACHE2](LICENSE).







We have [*lots of terraform modules*][terraform_modules] that are Open Source and we are trying to get them well-maintained!. Check them out!













## Makefile Targets
```
Available targets:

  help                                Help screen
  help/all                            Display help for all targets
  help/short                          This help short screen
  lint                                Lint terraform/opentofu code
  tag                                 Tag the current version

```
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

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
| <a name="input_association_zone_ids"></a> [association\_zone\_ids](#input\_association\_zone\_ids) | n/a | `set(string)` | `[]` | no |
| <a name="input_custom_resolver_rules"></a> [custom\_resolver\_rules](#input\_custom\_resolver\_rules) | Custom resolver rules to create | `any` | `{}` | no |
| <a name="input_dns_vpc"></a> [dns\_vpc](#input\_dns\_vpc) | n/a | <pre>object({<br/>    vpc_id     = optional(string, "")<br/>    vpc_region = optional(string, "us-east-1")<br/>  })</pre> | <pre>{<br/>  "vpc_id": "",<br/>  "vpc_region": ""<br/>}</pre> | no |
| <a name="input_enable_auto_accept"></a> [enable\_auto\_accept](#input\_enable\_auto\_accept) | n/a | `bool` | `true` | no |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | Extra tags to add to the resources | `map(string)` | `{}` | no |
| <a name="input_is_hub"></a> [is\_hub](#input\_is\_hub) | Is this a hub or spoke configuration? | `bool` | `false` | no |
| <a name="input_max_resolver_enis"></a> [max\_resolver\_enis](#input\_max\_resolver\_enis) | n/a | `number` | `-1` | no |
| <a name="input_org"></a> [org](#input\_org) | Organization details | <pre>object({<br/>    organization_name = string<br/>    organization_unit = string<br/>    environment_type  = string<br/>    environment_name  = string<br/>  })</pre> | n/a | yes |
| <a name="input_ram"></a> [ram](#input\_ram) | n/a | <pre>object({<br/>    enabled                   = optional(bool, true)<br/>    allow_external_principals = optional(bool, false)<br/>    principals                = optional(list(string), [])<br/>  })</pre> | <pre>{<br/>  "allow_external_principals": false,<br/>  "enabled": false,<br/>  "principals": []<br/>}</pre> | no |
| <a name="input_shared"></a> [shared](#input\_shared) | n/a | <pre>object({<br/>    ram_shares     = any<br/>    resolver_rules = any<br/>  })</pre> | <pre>{<br/>  "ram_shares": {},<br/>  "resolver_rules": {}<br/>}</pre> | no |
| <a name="input_spoke_def"></a> [spoke\_def](#input\_spoke\_def) | Spoke ID Number, must be a 3 digit number | `string` | `"001"` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | n/a | `list(string)` | `[]` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | n/a | `string` | `""` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | `""` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | n/a | `any` | `{}` | no |

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



## Help

**Got a question?** We got answers. 

File a GitHub [issue](https://github.com/cloudopsworks/terraform-module-aws-dns-setup/issues), send us an [email][email] or join our [Slack Community][slack].

[![README Commercial Support][readme_commercial_support_img]][readme_commercial_support_link]

## DevOps Tools

## Slack Community


## Newsletter

## Office Hours

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/cloudopsworks/terraform-module-aws-dns-setup/issues) to report any bugs or file feature requests.

### Developing




## Copyrights

Copyright © 2024-2025 [Cloud Ops Works LLC](https://cloudops.works)





## License 

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) 

See [LICENSE](LICENSE) for full details.

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

      https://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.









## Trademarks

All other trademarks referenced herein are the property of their respective owners.

## About

This project is maintained by [Cloud Ops Works LLC][website]. 


### Contributors

|  [![Cristian Beraha][berahac_avatar]][berahac_homepage]<br/>[Cristian Beraha][berahac_homepage] |
|---|

  [berahac_homepage]: https://github.com/berahac
  [berahac_avatar]: https://github.com/berahac.png?size=50

[![README Footer][readme_footer_img]][readme_footer_link]
[![Beacon][beacon]][website]

  [logo]: https://cloudops.works/logo-300x69.svg
  [docs]: https://cowk.io/docs?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-dns-setup&utm_content=docs
  [website]: https://cowk.io/homepage?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-dns-setup&utm_content=website
  [github]: https://cowk.io/github?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-dns-setup&utm_content=github
  [jobs]: https://cowk.io/jobs?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-dns-setup&utm_content=jobs
  [hire]: https://cowk.io/hire?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-dns-setup&utm_content=hire
  [slack]: https://cowk.io/slack?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-dns-setup&utm_content=slack
  [linkedin]: https://cowk.io/linkedin?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-dns-setup&utm_content=linkedin
  [twitter]: https://cowk.io/twitter?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-dns-setup&utm_content=twitter
  [testimonial]: https://cowk.io/leave-testimonial?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-dns-setup&utm_content=testimonial
  [office_hours]: https://cloudops.works/office-hours?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-dns-setup&utm_content=office_hours
  [newsletter]: https://cowk.io/newsletter?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-dns-setup&utm_content=newsletter
  [email]: https://cowk.io/email?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-dns-setup&utm_content=email
  [commercial_support]: https://cowk.io/commercial-support?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-dns-setup&utm_content=commercial_support
  [we_love_open_source]: https://cowk.io/we-love-open-source?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-dns-setup&utm_content=we_love_open_source
  [terraform_modules]: https://cowk.io/terraform-modules?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-dns-setup&utm_content=terraform_modules
  [readme_header_img]: https://cloudops.works/readme/header/img
  [readme_header_link]: https://cloudops.works/readme/header/link?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-dns-setup&utm_content=readme_header_link
  [readme_footer_img]: https://cloudops.works/readme/footer/img
  [readme_footer_link]: https://cloudops.works/readme/footer/link?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-dns-setup&utm_content=readme_footer_link
  [readme_commercial_support_img]: https://cloudops.works/readme/commercial-support/img
  [readme_commercial_support_link]: https://cloudops.works/readme/commercial-support/link?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-dns-setup&utm_content=readme_commercial_support_link
  [share_twitter]: https://twitter.com/intent/tweet/?text=Terraform+AWS+DNS+Setup+Module&url=https://github.com/cloudopsworks/terraform-module-aws-dns-setup
  [share_linkedin]: https://www.linkedin.com/shareArticle?mini=true&title=Terraform+AWS+DNS+Setup+Module&url=https://github.com/cloudopsworks/terraform-module-aws-dns-setup
  [share_reddit]: https://reddit.com/submit/?url=https://github.com/cloudopsworks/terraform-module-aws-dns-setup
  [share_facebook]: https://facebook.com/sharer/sharer.php?u=https://github.com/cloudopsworks/terraform-module-aws-dns-setup
  [share_googleplus]: https://plus.google.com/share?url=https://github.com/cloudopsworks/terraform-module-aws-dns-setup
  [share_email]: mailto:?subject=Terraform+AWS+DNS+Setup+Module&body=https://github.com/cloudopsworks/terraform-module-aws-dns-setup
  [beacon]: https://ga-beacon.cloudops.works/G-7XWMFVFXZT/cloudopsworks/terraform-module-aws-dns-setup?pixel&cs=github&cm=readme&an=terraform-module-aws-dns-setup
