##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

variable "zones" {
  type    = any
  default = {}
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "vpc_cidr_block" {
  type    = string
  default = ""
}

variable "dns_vpc" {
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
  type    = list(string)
  default = []
}

variable "ram" {
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
  type    = bool
  default = true
}

variable "shared" {
  type = object({
    ram_shares     = any
    resolver_rules = any
  })
  default = {
    ram_shares     = {}
    resolver_rules = {}
  }
}

variable "association_zone_ids" {
  type    = set(string)
  default = []
}

variable "custom_resolver_rules" {
  description = "Custom resolver rules to create"
  type        = any
  default     = {}
}

variable "max_resolver_enis" {
  type    = number
  default = -1
  validation {
    condition     = var.max_resolver_enis == -1 || var.max_resolver_enis >= 2
    error_message = "max_resolver_enis must be -1 (All) or greater than or equal to 2"
  }
}