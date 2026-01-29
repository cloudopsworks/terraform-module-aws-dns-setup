##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#
locals {
  custom_resolver_rules = {
    for k, v in var.custom_resolver_rules :
    k => v
    if var.is_hub == true
  }
  hub_resolver_zones = toset([
    for k, v in local.private_zones :
    v.domain_name
    if var.is_hub == true
  ])
  subnet_list = var.max_resolver_enis > 0 ? slice(var.subnet_ids, 0, var.max_resolver_enis) : var.subnet_ids
  ip_address_obj = [
    for subnet in local.subnet_list : {
      subnet_id = subnet
    }
  ]
}

# Resolve the inbound domain with inbound resolver through te outbound resolver
resource "aws_route53_resolver_rule" "inbound_rules" {
  depends_on           = [module.resolver_endpoint_out]
  for_each             = local.hub_resolver_zones
  name                 = "rslvr-rr-in-${replace(lower(each.key), ".", "-")}-${local.system_name}"
  domain_name          = lower(each.value)
  rule_type            = "FORWARD"
  resolver_endpoint_id = module.resolver_endpoint_out.id
  dynamic "target_ip" {
    for_each = module.resolver_endpoint_in.ip_addresses
    content {
      ip = target_ip.value.ip
    }
  }
  tags = local.all_tags
}

# Resolve custom rules into inbound resolver
resource "aws_route53_resolver_rule" "custom_inbound_rules" {
  depends_on           = [module.resolver_endpoint_out]
  for_each             = local.custom_resolver_rules
  name                 = "rslvr-rr-in-${replace(each.key, ".", "-")}-${local.system_name}"
  domain_name          = lower(each.value.domain_name)
  rule_type            = upper(try(each.value.rule_type, "FORWARD"))
  resolver_endpoint_id = module.resolver_endpoint_out.id
  dynamic "target_ip" {
    for_each = try(each.value.addresses, module.resolver_endpoint_in.ip_addresses)
    content {
      ip = target_ip.value.ip
    }
  }
  tags = local.all_tags
}


resource "aws_route53_resolver_rule_association" "inbound_rules" {
  depends_on       = [aws_ram_resource_association.inbound_rules, aws_ram_resource_share_accepter.inbound_rules]
  for_each         = var.shared.resolver_rules
  name             = "rra-${replace(lower(try(each.value.domain_name, each.value.rule_name)), ".", "-")}-${var.vpc_id}-${local.system_name_short}"
  resolver_rule_id = each.value.id
  vpc_id           = var.vpc_id
}

resource "aws_route53_resolver_rule_association" "custom_inbound_rules" {
  depends_on       = [aws_ram_resource_association.inbound_rules, aws_ram_resource_share_accepter.inbound_rules]
  for_each         = { for k, v in local.custom_resolver_rules : k => v if try(v.associate_vpc, false) == true }
  name             = "rra-${replace(lower(each.key), ".", "-")}-${var.vpc_id}-${local.system_name_short}"
  resolver_rule_id = aws_route53_resolver_rule.custom_inbound_rules[each.key].id
  vpc_id           = var.vpc_id
}

module "resolver_endpoint_in" {
  depends_on          = [aws_route53_zone.this]
  source              = "terraform-aws-modules/route53/aws//modules/resolver-endpoint"
  version             = "~> 6.3"
  create              = var.is_hub
  name                = "rslvr-in-${local.system_name}"
  direction           = "INBOUND"
  ip_address          = local.ip_address_obj
  vpc_id              = var.vpc_id
  protocols           = ["DoH", "Do53"]
  security_group_name = "rslvr-in-${local.system_name}-sg"
  security_group_tags = local.all_tags
  security_group_ingress_rules = {
    vpc = {
      cidr_ipv4 = var.vpc_cidr_block
    }
  }
  tags = local.all_tags
}

module "resolver_endpoint_out" {
  depends_on          = [aws_route53_zone.this]
  source              = "terraform-aws-modules/route53/aws//modules/resolver-endpoint"
  version             = "~> 6.3"
  create              = var.is_hub
  name                = "rslvr-out-${local.system_name}"
  direction           = "OUTBOUND"
  ip_address          = local.ip_address_obj
  vpc_id              = var.vpc_id
  protocols           = ["DoH", "Do53"]
  security_group_name = "rslvr-out-${local.system_name}-sg"
  security_group_tags = local.all_tags
  security_group_ingress_rules = {
    vpc = {
      cidr_ipv4 = var.vpc_cidr_block
    }
  }
  tags = local.all_tags
}