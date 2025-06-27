##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

## Zones Definitions - YAML:
#zones:
#  <zone_name>:
#    domain_name: <domain_name>
#    comment: <comment>
#    private: <true|false>
#    force_destroy: <true|false>
#    delegation_set_id: <delegation_set_id>
#    tags:
#      <tag_key>: <tag_value>
#      <tag_key>: <tag_value>
variable "zones" {
  description = "Map of Route53 zones to create. Each key is the zone name, and the value is an object with the following attributes: domain_name, comment, private (boolean), force_destroy (boolean), delegation_set_id (optional), tags (optional)."
  type        = any
  default     = {}
}

variable "vpc_id" {
  description = "VPC ID to associate with the Route53 zones. This is required for private zones."
  type        = string
  default     = ""
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC. This is required for private zones."
  type        = string
  default     = ""
}

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

variable "subnet_ids" {
  description = "List of subnet IDs where the DNS resolver will be deployed. This is required for creating the resolver endpoints."
  type        = list(string)
  default     = []
}

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

variable "enable_auto_accept" {
  description = "Enable automatic acceptance of RAM shares for the DNS resolver. This is useful when sharing the resolver with other accounts."
  type        = bool
  default     = true
}

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
#association_zone_ids:
#  - <zone_id_1>
#  - <zone_id_2>
variable "association_zone_ids" {
  description = "List of Route53 zone IDs to associate with the DNS resolver. This is used to link the resolver with specific zones for DNS resolution."
  type    = set(string)
  default = []
}

## Custom Resolver Rules - YAML Format:
#custom_resolver_rules:
#  <rule_name>:
#    domain_name: <domain_name>
#    rule_type: <FORWARD or SYSTEM> (default: FORWARD)
#    addresses: [<ip_address_1>, <ip_address_2>, ...] (optional, defaults to resolver endpoint IPs)
#    associate_vpc: <true or false> (default: false)
variable "custom_resolver_rules" {
  description = "Map of custom resolver rules to create. Each key is the rule name, and the value is an object with the following attributes: domain_name, rule_type (FORWARD or SYSTEM), addresses (optional list of IP addresses), associate_vpc (boolean)."
  type        = any
  default     = {}
}

variable "max_resolver_enis" {
  description = "Maximum number of resolver ENIs to create. Set to -1 for all available ENIs, or a specific number greater than or equal to 2."
  type        = number
  default     = -1
  validation {
    condition     = var.max_resolver_enis == -1 || var.max_resolver_enis >= 2
    error_message = "max_resolver_enis must be -1 (All) or greater than or equal to 2"
  }
}