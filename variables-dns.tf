##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

## Zones Definitions - YAML:
# | Field             | Type    | Required | Default                | Description                                                    |
# |-------------------|---------|----------|------------------------|----------------------------------------------------------------|
# | domain_name       | string  | Yes      | -                      | The domain name of the Route53 zone.                           |
# | comment           | string  | No       | "Managed by Terraform" | A comment for the Route53 zone.                                |
# | private           | boolean | No       | false                  | Whether the zone is private or public.                         |
# | force_destroy     | boolean | No       | false                  | Whether to force destroy the zone even if it contains records. |
# | delegation_set_id | string  | No       | null                   | The ID of the delegation set to use for the zone.              |
# | tags              | map     | No       | {}                     | A map of tags to assign to the zone.                           |
#
# Private zones (private: true) are associated with `vpc_id` at creation time, so `vpc_id`
# must be set whenever at least one zone is declared private. `delegation_set_id` applies to
# public zones only.
#
# zones:
#   example-zone:
#     domain_name: "example.com"      # (Required) The domain name of the Route53 zone.
#     comment: "Example zone"         # (Optional) A comment for the Route53 zone. (Default: "Managed by Terraform")
#     private: true                   # (Optional) Whether the zone is private or public. (Default: false)
#     force_destroy: false            # (Optional) Whether to force destroy the zone even if it contains records. (Default: false)
#     delegation_set_id: "N1234567"   # (Optional) The ID of the delegation set to use for the zone. Public zones only. (Default: null)
#     tags:                           # (Optional) A map of tags to assign to the zone. (Default: {})
#       Environment: "prod"
variable "zones" {
  description = "(Optional) Map of Route53 zones to create, keyed by an arbitrary zone key. Each value accepts domain_name, comment, private, force_destroy, delegation_set_id and tags. (Default: {})"
  type        = any
  default     = {}
}

# vpc_id: "vpc-12345678"               # (Optional) VPC ID to associate with private zones and to host the resolver endpoints. Required for private zones and when is_hub is true. (Default: "")
variable "vpc_id" {
  description = "(Optional) VPC ID to associate with the Route53 private zones and to host the resolver endpoints. Required when any zone is private or when is_hub is true. (Default: \"\")"
  type        = string
  default     = ""
}

# vpc_cidr_block: "10.0.0.0/16"        # (Optional) CIDR block allowed to reach the resolver endpoints. Required when is_hub is true. (Default: "")
variable "vpc_cidr_block" {
  description = "(Optional) CIDR block of the VPC, used as the ingress rule of the resolver endpoint security groups. Required when is_hub is true. (Default: \"\")"
  type        = string
  default     = ""
}

## DNS VPC Configuration - YAML:
# | Field      | Type   | Required | Default | Description                                                |
# |------------|--------|----------|---------|------------------------------------------------------------|
# | vpc_id     | string | No       | ""      | ID of the remote VPC authorized to associate to the zones. |
# | vpc_region | string | No       | ""      | AWS region of that remote VPC.                             |
#
# Setting `dns_vpc.vpc_id` makes this deployment emit a cross-account VPC association
# authorization for every private zone it creates. Leave it empty to skip that authorization.
# The authorized account must still complete the association on its own side.
#
# dns_vpc:
#   vpc_id: "vpc-12345678"             # (Optional) ID of the remote VPC to authorize against the private zones. (Default: "")
#   vpc_region: "us-east-1"            # (Optional) AWS region of the remote VPC. (Default: "")
variable "dns_vpc" {
  description = "(Optional) Remote VPC authorized to associate with the private zones created here. When vpc_id is empty no association authorization is emitted. (Default: {vpc_id = \"\", vpc_region = \"\"})"
  type = object({
    vpc_id     = optional(string, "")
    vpc_region = optional(string, "us-east-1")
  })
  default = {
    vpc_id     = ""
    vpc_region = ""
  }
}

# subnet_ids: ["subnet-1", "subnet-2"] # (Optional) Subnets that host the resolver endpoint ENIs. At least two are required when is_hub is true. (Default: [])
variable "subnet_ids" {
  description = "(Optional) List of subnet IDs where the resolver endpoint ENIs are placed. At least two subnets in distinct AZs are required when is_hub is true. (Default: [])"
  type        = list(string)
  default     = []
}

## RAM Configuration - YAML:
# | Field                     | Type         | Required | Default | Description                                       |
# |---------------------------|--------------|----------|---------|---------------------------------------------------|
# | enabled                   | boolean      | No       | true    | Enable Resource Access Manager (RAM) sharing.     |
# | allow_external_principals | boolean      | No       | false   | Allow sharing with principals outside the org.    |
# | principals                | list(string) | No       | []      | AWS account IDs or Organizations/OU ARNs.         |
#
# Note on the `enabled` default: when the whole `ram` block is omitted the module falls back to
# its variable-level default, which is `enabled: false`. When the `ram` block IS supplied but
# `enabled` is left out, the attribute default applies and sharing is ENABLED. Set `enabled`
# explicitly whenever you declare the block.
#
# On a hub, `enabled: true` shares the generated resolver rules out. On a spoke, `enabled: true`
# is what allows `shared.ram_shares` to be accepted.
#
# ram:
#   enabled: true                      # (Optional) Enable Resource Access Manager (RAM) sharing. (Default: true when the block is present, false when omitted)
#   allow_external_principals: false   # (Optional) Allow sharing with principals outside the AWS Organization. (Default: false)
#   principals: ["123456789012"]       # (Optional) AWS account IDs or Organizations/OU ARNs to share with. (Default: [])
variable "ram" {
  description = "(Optional) Resource Access Manager sharing configuration for the resolver rules. Controls whether sharing is enabled, whether external principals are allowed and which principals receive the shares. (Default: sharing disabled)"
  type = object({
    enabled                   = optional(bool, true)
    allow_external_principals = optional(bool, false)
    principals                = optional(list(string), [])
  })
  default = {
    enabled                   = false
    allow_external_principals = false
    principals                = []
  }
}

# enable_auto_accept: true             # (Optional) Reserved flag for automatic acceptance of RAM shares. Not consumed by any resource in the current implementation. (Default: true)
variable "enable_auto_accept" {
  description = "(Optional) Reserved flag for automatic acceptance of RAM shares. Currently declared for interface stability and not consumed by any resource; acceptance is driven by shared.ram_shares together with ram.enabled. (Default: true)"
  type        = bool
  default     = true
}

## Shared Configuration - YAML:
# | Field          | Type | Required | Default | Description                                              |
# |----------------|------|----------|---------|----------------------------------------------------------|
# | ram_shares     | any  | Yes*     | {}      | RAM resource shares, received from the hub, to accept.   |
# | resolver_rules | any  | Yes*     | {}      | Resolver rules, received from the hub, to associate.     |
#
# (*) Both keys are required whenever the `shared` block itself is supplied - they have no
# attribute-level defaults. Omit the whole block to fall back to two empty maps.
#
# This is the spoke-side counterpart of the hub `ram` output. Each `ram_shares` entry needs an
# `arn`; each `resolver_rules` entry needs an `id` plus a `domain_name` (or `rule_name`) used to
# build the association name. Acceptance of the shares also requires `ram.enabled` to be true.
#
# shared:
#   ram_shares:                        # (Required when `shared` is set) RAM shares to accept, keyed by share name.
#     hub-share:
#       arn: "arn:aws:ram:us-east-1:123456789012:resource-share/abcd-1234"
#   resolver_rules:                    # (Required when `shared` is set) Resolver rules to associate to this VPC, keyed by rule name.
#     hub-rule:
#       id: "rslvr-rr-1234567890"      # (Required) ID of the shared resolver rule.
#       domain_name: "example.internal" # (Required) Domain of the rule; `rule_name` is accepted as a fallback.
variable "shared" {
  description = "(Optional) Spoke-side configuration consuming what a hub shared out: RAM resource shares to accept and resolver rules to associate with this VPC. Both keys are mandatory once the object is supplied. (Default: both empty)"
  type = object({
    ram_shares     = any
    resolver_rules = any
  })
  default = {
    ram_shares     = {}
    resolver_rules = {}
  }
}

## Association Zone IDs - YAML:
# Pre-existing Route53 private zones - typically created elsewhere or shared by another account -
# that should be associated with `vpc_id`. Zones created by this module through `zones` are
# associated automatically and must not be listed here.
#
# association_zone_ids:
#   - "Z1234567890"                    # (Optional) ID of an existing private zone to associate with vpc_id. (Default: [])
variable "association_zone_ids" {
  description = "(Optional) Set of existing Route53 private zone IDs to associate with vpc_id. Zones created by this module are associated automatically and should not be listed. (Default: [])"
  type        = set(string)
  default     = []
}

## Custom Resolver Rules - YAML:
# | Field         | Type         | Required | Default              | Description                                 |
# |---------------|--------------|----------|----------------------|---------------------------------------------|
# | domain_name   | string       | Yes      | -                    | Domain name the rule matches.               |
# | rule_type     | string       | No       | "FORWARD"            | Type of resolver rule. (FORWARD, SYSTEM)    |
# | addresses     | list(object) | No       | inbound resolver IPs | Target IPs, each as an object with an `ip`. |
# | associate_vpc | boolean      | No       | false                | Associate the rule with `vpc_id`.           |
#
# Only evaluated when `is_hub` is true; on a spoke the map is ignored. Use these rules to forward
# a domain to on-premises or third-party DNS servers. When `addresses` is omitted the rule targets
# the IPs of this hub's inbound resolver endpoint.
#
# custom_resolver_rules:
#   rule1:
#     domain_name: "onprem.internal"   # (Required) Domain name the resolver rule matches.
#     rule_type: "FORWARD"             # (Optional) Type of resolver rule. Possible values: FORWARD, SYSTEM. (Default: FORWARD)
#     addresses:                       # (Optional) Target IP addresses for the rule. (Default: this hub's inbound resolver IPs)
#       - ip: "10.0.0.1"
#       - ip: "10.0.1.1"
#     associate_vpc: true              # (Optional) Whether to associate the rule with vpc_id. (Default: false)
variable "custom_resolver_rules" {
  description = "(Optional) Map of custom Route53 Resolver rules to create, keyed by rule name. Each value accepts domain_name, rule_type, addresses and associate_vpc. Only applied when is_hub is true. (Default: {})"
  type        = any
  default     = {}
}

# max_resolver_enis: -1                # (Optional) Cap on the number of subnets used for resolver ENIs. -1 uses every subnet in subnet_ids. (Default: -1)
variable "max_resolver_enis" {
  description = "(Optional) Maximum number of resolver ENIs to create, taken from the head of subnet_ids. Use -1 for all supplied subnets, or a value greater than or equal to 2. (Default: -1)"
  type        = number
  default     = -1
  validation {
    condition     = var.max_resolver_enis == -1 || var.max_resolver_enis >= 2
    error_message = "max_resolver_enis must be -1 (All) or greater than or equal to 2"
  }
}
