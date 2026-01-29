##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

## Zones Definitions - YAML:
# | Field             | Type    | Required | Default                | Description                                                                        |
# |-------------------|---------|----------|------------------------|------------------------------------------------------------------------------------|
# | domain_name       | string  | Yes      | -                      | The domain name of the Route53 zone.                                               |
# | comment           | string  | No       | "Managed by Terraform" | A comment for the Route53 zone.                                                    |
# | private           | boolean | No       | false                  | Whether the zone is private or public.                                             |
# | force_destroy     | boolean | No       | false                  | Whether to force destroy the zone even if it contains records.                     |
# | delegation_set_id | string  | No       | null                   | The ID of the delegation set to use for the zone.                                  |
# | tags              | map     | No       | {}                     | A map of tags to assign to the zone.                                               |
#
# zones:
#   example-zone:
#     domain_name: "example.com"      # (Required) The domain name of the Route53 zone.
#     comment: "Example zone"         # (Optional) A comment for the Route53 zone. (Default: "Managed by Terraform")
#     private: true                   # (Optional) Whether the zone is private or public. (Default: false)
#     force_destroy: false            # (Optional) Whether to force destroy the zone even if it contains records. (Default: false)
#     delegation_set_id: "N1234567"   # (Optional) The ID of the delegation set to use for the zone. (Default: null)
#     tags:                           # (Optional) A map of tags to assign to the zone. (Default: {})
#       Environment: "prod"
variable "zones" {
  description = "Map of Route53 zones to create. Each key is the zone name, and the value is an object with the following attributes: domain_name, comment, private (boolean), force_destroy (boolean), delegation_set_id (optional), tags (optional)."
  type        = any
  default     = {}
}

# vpc_id: "vpc-12345678"               # (Optional) VPC ID to associate with the Route53 zones. This is required for private zones. (Default: "")
variable "vpc_id" {
  description = "VPC ID to associate with the Route53 zones. This is required for private zones."
  type        = string
  default     = ""
}

# vpc_cidr_block: "10.0.0.0/16"        # (Optional) CIDR block for the VPC. This is required for private zones. (Default: "")
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC. This is required for private zones."
  type        = string
  default     = ""
}

## DNS VPC Configuration - YAML:
# | Field      | Type   | Required | Default       | Description                                  |
# |------------|--------|----------|---------------|----------------------------------------------|
# | vpc_id     | string | No       | ""            | VPC ID for the DNS resolver.                 |
# | vpc_region | string | No       | "us-east-1"   | AWS region for the DNS resolver.             |
#
# dns_vpc:
#   vpc_id: "vpc-12345678"             # (Optional) VPC ID for the DNS resolver. (Default: "")
#   vpc_region: "us-east-1"            # (Optional) AWS region for the DNS resolver. (Default: "us-east-1")
variable "dns_vpc" {
  description = "VPC configuration for DNS resolver. This is used to specify the VPC ID and region where the DNS resolver will be created."
  type = object({
    vpc_id     = optional(string, "")
    vpc_region = optional(string, "us-east-1")
  })
  default = {
    vpc_id     = ""
    vpc_region = ""
  }
}

# subnet_ids: ["subnet-1", "subnet-2"] # (Optional) List of subnet IDs where the DNS resolver will be deployed. (Default: [])
variable "subnet_ids" {
  description = "List of subnet IDs where the DNS resolver will be deployed. This is required for creating the resolver endpoints."
  type        = list(string)
  default     = []
}

## RAM Configuration - YAML:
# | Field                     | Type         | Required | Default | Description                                              |
# |---------------------------|--------------|----------|---------|----------------------------------------------------------|
# | enabled                   | boolean      | No       | false   | Enable Resource Access Manager (RAM) sharing.             |
# | allow_external_principals | boolean      | No       | false   | Allow sharing with external principals.                  |
# | principals                | list(string) | No       | []      | List of AWS account IDs or OU ARNs to share with.        |
#
# ram:
#   enabled: true                      # (Optional) Enable Resource Access Manager (RAM) sharing. (Default: false)
#   allow_external_principals: false   # (Optional) Allow sharing with external principals. (Default: false)
#   principals: ["123456789012"]       # (Optional) List of AWS account IDs or OU ARNs to share with. (Default: [])
variable "ram" {
  description = "Resource Access Manager (RAM) configuration for sharing the DNS resolver across accounts. This includes whether to enable sharing, allow external principals, and a list of principals to share with."
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

# enable_auto_accept: true             # (Optional) Enable automatic acceptance of RAM shares for the DNS resolver. (Default: true)
variable "enable_auto_accept" {
  description = "Enable automatic acceptance of RAM shares for the DNS resolver. This is useful when sharing the resolver with other accounts."
  type        = bool
  default     = true
}

## Shared Configuration - YAML:
# | Field          | Type | Required | Default | Description                      |
# |----------------|------|----------|---------|----------------------------------|
# | ram_shares     | any  | No       | {}      | RAM shares configuration.        |
# | resolver_rules | any  | No       | {}      | Resolver rules configuration.    |
#
# shared:
#   ram_shares: {}                     # (Optional) RAM shares configuration. (Default: {})
#   resolver_rules: {}                 # (Optional) Resolver rules configuration. (Default: {})
variable "shared" {
  description = "Shared configuration for the DNS resolver, including RAM shares and resolver rules. This is used to define how the resolver will be shared across accounts and any custom resolver rules."
  type = object({
    ram_shares     = any
    resolver_rules = any
  })
  default = {
    ram_shares     = {}
    resolver_rules = {}
  }
}

## Association Zone IDs - Yaml Format:
# association_zone_ids:
#   - "Z1234567890"                    # (Optional) List of Route53 zone IDs to associate with the DNS resolver. (Default: [])
variable "association_zone_ids" {
  description = "List of Route53 zone IDs to associate with the DNS resolver. This is used to link the resolver with specific zones for DNS resolution."
  type        = set(string)
  default     = []
}

## Custom Resolver Rules - YAML Format:
# | Field         | Type         | Required | Default                | Description                                              |
# |---------------|--------------|----------|------------------------|----------------------------------------------------------|
# | domain_name   | string       | Yes      | -                      | Domain name for the resolver rule.                       |
# | rule_type     | string       | No       | "FORWARD"              | Type of resolver rule. (FORWARD, SYSTEM)                 |
# | addresses     | list(string) | No       | inbound resolver IPs   | Target IP addresses for the rule.                        |
# | associate_vpc | boolean      | No       | false                  | Whether to associate the rule with the VPC.              |
#
# custom_resolver_rules:
#   rule1:
#     domain_name: "onprem.internal"   # (Required) Domain name for the resolver rule.
#     rule_type: "FORWARD"             # (Optional) Type of resolver rule. Possible values: FORWARD, SYSTEM. (Default: FORWARD)
#     addresses: ["10.0.0.1"]          # (Optional) Target IP addresses for the rule. (Default: inbound resolver IPs)
#     associate_vpc: true              # (Optional) Whether to associate the rule with the VPC. (Default: false)
variable "custom_resolver_rules" {
  description = "Map of custom resolver rules to create. Each key is the rule name, and the value is an object with the following attributes: domain_name, rule_type (FORWARD or SYSTEM), addresses (optional list of IP addresses), associate_vpc (boolean)."
  type        = any
  default     = {}
}

# max_resolver_enis: -1                # (Optional) Maximum number of resolver ENIs to create. (Default: -1)
variable "max_resolver_enis" {
  description = "Maximum number of resolver ENIs to create. Set to -1 for all available ENIs, or a specific number greater than or equal to 2."
  type        = number
  default     = -1
  validation {
    condition     = var.max_resolver_enis == -1 || var.max_resolver_enis >= 2
    error_message = "max_resolver_enis must be -1 (All) or greater than or equal to 2"
  }
}