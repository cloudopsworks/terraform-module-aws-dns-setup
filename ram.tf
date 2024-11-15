##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

locals {
  shared_hub_resolver_zones = toset([
    for k, v in local.private_zones :
    v.domain_name
    if var.is_hub == true && var.ram.enabled == true
  ])
  shared_custom_resolver_rules = {
    for k, v in var.custom_resolver_rules :
    k => v
    if var.is_hub == true && var.ram.enabled == true
  }
}

# Inbound rules sharing
resource "aws_ram_resource_share" "inbound_rules" {
  for_each                  = local.shared_hub_resolver_zones
  name                      = aws_route53_resolver_rule.inbound_rules[each.key].name
  allow_external_principals = var.ram.allow_external_principals
  tags = merge(
    {
      Name = "rslvr-${replace(each.value, ".", "-")}-${local.system_name}"
    },
    local.all_tags
  )
}

resource "aws_ram_resource_association" "inbound_rules" {
  for_each           = local.shared_hub_resolver_zones
  resource_arn       = aws_route53_resolver_rule.inbound_rules[each.key].arn
  resource_share_arn = aws_ram_resource_share.inbound_rules[each.key].arn
}

resource "aws_ram_principal_association" "inbound_rules" {
  for_each = merge([for p in var.ram.principals :
    { for d in local.shared_hub_resolver_zones : "${d}-${p}" => {
      domain_name = d
      principal   = p
      }
    }
  ]...)
  principal          = each.value.principal
  resource_share_arn = aws_ram_resource_share.inbound_rules[each.value.domain_name].arn
}

# Custom inbound rules sharing
resource "aws_ram_resource_share" "custom_inbound_rules" {
  for_each                  = local.shared_custom_resolver_rules
  name                      = aws_route53_resolver_rule.custom_inbound_rules[each.key].name
  allow_external_principals = var.ram.allow_external_principals
  tags = merge(
    {
      Name = "rslvr-${replace(each.key, ".", "-")}-${local.system_name}"
    },
    local.all_tags
  )
}

resource "aws_ram_resource_association" "custom_inbound_rules" {
  for_each           = local.shared_custom_resolver_rules
  resource_arn       = aws_route53_resolver_rule.custom_inbound_rules[each.key].arn
  resource_share_arn = aws_ram_resource_share.custom_inbound_rules[each.key].arn
}

resource "aws_ram_principal_association" "custom_inbound_rules" {
  for_each = merge([for p in var.ram.principals :
    { for k, v in local.shared_custom_resolver_rules : "${k}-${p}" => {
      rule_name = k
      principal = p
      }
    }
  ]...)
  principal          = each.value.principal
  resource_share_arn = aws_ram_resource_share.custom_inbound_rules[each.value.rule_name].arn
}


resource "aws_ram_resource_share_accepter" "inbound_rules" {
  for_each = {
    for k, v in var.shared.ram_shares :
    k => v
    if var.ram.enabled
  }
  share_arn = each.value.arn
}