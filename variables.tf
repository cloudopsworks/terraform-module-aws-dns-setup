##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

# Establish this is a HUB or spoke configuration
variable "is_hub" {
  type    = bool
  default = false
}

variable "spoke_def" {
  type    = string
  default = "001"
}

variable "org" {
  type = object({
    organization_name = string
    organization_unit = string
    environment_type  = string
    environment_name  = string
  })
}

variable "extra_tags" {
  type    = map(string)
  default = {}
}

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

variable "subnet_ids" {
  type    = list(string)
  default = []
}

variable "ram" {
  type = object({
    enabled                   = optional(bool, true)
    allow_external_principals = optional(bool, false)
    principals                = optional(list(string), [])
    share_ids                 = optional(set(string), [])
  })
  default = {
    enabled                   = false
    allow_external_principals = false
    principals                = []
    share_ids                 = []
  }
}

variable "enable_auto_accept" {
  type    = bool
  default = true
}
