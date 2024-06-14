##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

resource "aws_ram_resource_share" "inbound_rules" {
  for_each                  = local.hub_resolver_zones
  provider                  = aws.default
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
  for_each           = local.hub_resolver_zones
  provider           = aws.default
  resource_arn       = aws_route53_resolver_rule.inbound_rules[each.key].arn
  resource_share_arn = aws_ram_resource_share.inbound_rules[each.key].arn
}

resource "aws_ram_principal_association" "inbound_rules" {
  for_each = merge([for p in var.ram.principals :
    { for d in local.hub_resolver_zones : "${d}-${p}" => {
      domain_name = d
      principal   = p
      }
    }
  ]...)
  provider           = aws.default
  principal          = each.value.principal
  resource_share_arn = aws_ram_resource_share.inbound_rules[each.value.domain_name].arn
}


resource "aws_ram_resource_share_accepter" "inbound_rules" {
  provider  = aws.default
  for_each  = var.shared.ram_shares
  share_arn = each.value.arn
}