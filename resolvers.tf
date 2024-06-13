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
resource "aws_route53_resolver_rule" "outbound_rules" {
  depends_on           = [module.resolver_endpoints]
  for_each             = local.resolver_zones
  provider             = aws.default
  name                 = "rslvr-out-${replace(each.key,".","-")}-${local.system_name}"
  domain_name          = each.value.domain_name
  rule_type            = "FORWARD"
  resolver_endpoint_id = module.resolver_endpoints[0].route53_resolver_endpoint_id
  tags                 = local.all_tags
}

module "resolver_endpoints" {
  count      = var.is_hub ? 1 : 0
  depends_on = [module.dns]
  providers = {
    aws = aws.default
  }
  source  = "terraform-aws-modules/route53/aws//modules/resolver-endpoints"
  version = "~> 3.0"

  create              = true
  name                = "rslvr-ep-${local.system_name}"
  security_group_name = "rslvr-ep-sg-${local.system_name}"
  direction           = "OUTBOUND"
  subnet_ids          = var.subnet_ids
  vpc_id              = var.vpc_id
  protocols           = ["DoH", "Do53"]
  tags                = local.all_tags
}