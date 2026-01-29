##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

## Hub or Spoke Configuration - YAML:
# is_hub: false                        # (Optional) Whether this instance acts as a DNS Hub. (Default: false)
variable "is_hub" {
  description = "Is this a hub or spoke configuration?"
  type        = bool
  default     = false
}

## Spoke Identifier - YAML:
# spoke_def: "001"                     # (Optional) 3-digit spoke identifier. (Default: "001")
variable "spoke_def" {
  description = "Spoke ID Number, must be a 3 digit number"
  type        = string
  default     = "001"
  validation {
    condition     = (length(var.spoke_def) == 3) && tonumber(var.spoke_def) != null
    error_message = "The spoke_def must be a 3 digit number as string."
  }
}

## Organization Details - YAML:
# | Field             | Type   | Required | Default | Description                                         |
# |-------------------|--------|----------|---------|-----------------------------------------------------|
# | organization_name | string | Yes      | -       | The name of the organization.                       |
# | organization_unit | string | Yes      | -       | The organizational unit.                            |
# | environment_type  | string | Yes      | -       | Type of environment (e.g. prod, non-prod).          |
# | environment_name  | string | Yes      | -       | Specific environment name (e.g. production, dev).   |
#
# org:
#   organization_name: "example"       # (Required) The name of the organization.
#   organization_unit: "platform"      # (Required) The organizational unit.
#   environment_type: "prod"           # (Required) Type of environment (e.g., prod, non-prod).
#   environment_name: "production"     # (Required) Specific environment name.
variable "org" {
  description = "Organization details"
  type = object({
    organization_name = string
    organization_unit = string
    environment_type  = string
    environment_name  = string
  })
}

## Extra Tags - YAML:
# extra_tags:                          # (Optional) Extra tags to add to the resources. (Default: {})
#   Tag1: "Value1"
variable "extra_tags" {
  description = "Extra tags to add to the resources"
  type        = map(string)
  default     = {}
}
