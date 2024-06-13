##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#
locals {
  resolver_zones = {
    for k, v in local.private_zones : k => v
    if var.is_hub == true
  }
}
resource "aws_route53_resolver_rule" "inbound_rules" {
  depends_on           = [module.resolver_endpoint_out]
  for_each             = local.resolver_zones
  provider             = aws.default
  name                 = "rslvr-in-${replace(each.key, ".", "-")}-${local.system_name}"
  domain_name          = each.value.domain_name
  rule_type            = "FORWARD"
  resolver_endpoint_id = module.resolver_endpoint_in[0].route53_resolver_endpoint_id
  dynamic "target_ip" {
    for_each = module.resolver_endpoint_in[0].route53_resolver_endpoint_ip_addresses
    content {
      ip = target_ip.value.ip
    }
  }
  tags = local.all_tags
}

resource "aws_route53_resolver_rule_association" "inbound_rules" {
  for_each         = local.resolver_zones
  provider         = aws.default
  name             = "rslvr-rra-${replace(each.key, ".", "-")}-${var.vpc_id}-${local.system_name}"
  resolver_rule_id = aws_route53_resolver_rule.inbound_rules[each.key].id
  vpc_id           = var.vpc_id
}

module "resolver_endpoint_in" {
  count      = var.is_hub ? 1 : 0
  depends_on = [module.dns]
  providers = {
    aws = aws.default
  }
  source  = "terraform-aws-modules/route53/aws//modules/resolver-endpoints"
  version = "~> 3.0"

  create              = true
  name                = "rslvr-in-${local.system_name}"
  direction           = "INBOUND"
  subnet_ids          = var.subnet_ids
  vpc_id              = var.vpc_id
  protocols           = ["DoH", "Do53"]
  tags                = local.all_tags
  security_group_name = "rslvr-in-sg-${local.system_name}"
  security_group_ingress_cidr_blocks = [
    var.vpc_cidr_block
  ]
  security_group_tags = local.all_tags
}

module "resolver_endpoint_out" {
  count      = var.is_hub ? 1 : 0
  depends_on = [module.dns]
  providers = {
    aws = aws.default
  }
  source  = "terraform-aws-modules/route53/aws//modules/resolver-endpoints"
  version = "~> 3.0"

  create              = true
  name                = "rslvr-out-${local.system_name}"
  direction           = "OUTBOUND"
  subnet_ids          = var.subnet_ids
  vpc_id              = var.vpc_id
  protocols           = ["DoH", "Do53"]
  tags                = local.all_tags
  security_group_name = "rslvr-out-sg-${local.system_name}"
  security_group_ingress_cidr_blocks = [
    var.vpc_cidr_block
  ]
  security_group_tags = local.all_tags
}