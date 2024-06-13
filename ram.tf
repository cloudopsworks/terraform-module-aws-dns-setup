##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

resource "aws_ram_resource_share" "outbound_rules" {
  for_each                  = local.resolver_zones
  provider                  = aws.default
  name                      = aws_route53_resolver_rule.outbound_rules[each.key].name
  allow_external_principals = var.ram.allow_external_principals
  tags = merge(
    {
      Name = "rslvr-${replace(each.key, ".", "-")}-${local.system_name}"
    },
    local.all_tags
  )
}

resource "aws_ram_resource_association" "outbound_rules" {
  for_each           = local.resolver_zones
  provider           = aws.default
  resource_arn       = aws_route53_resolver_rule.outbound_rules[each.key].arn
  resource_share_arn = aws_ram_resource_share.outbound_rules[each.key].arn
}

resource "aws_ram_principal_association" "outbound_rules" {
  for_each = merge([for p in var.ram.principals :
    { for k, v in local.resolver_zones : "${k}-${p}" => {
      domain_name = v.domain_name
      principal   = p
      }
    }
  ]...)
  provider           = aws.default
  principal          = each.value.principal
  resource_share_arn = aws_ram_resource_share.outbound_rules[each.key].arn
}
