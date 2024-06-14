##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

locals {
  private_zones = {
    for k, v in var.zones : k => {
      domain_name = v.domain_name
      comment     = v.comment
      tags        = v.tags
      vpc = {
        vpc_id = var.vpc_id
      }
    } if try(v.private, false) == true
  }
  public_zones = {
    for k, v in var.zones : k => {
      domain_name = v.domain_name
      comment     = v.comment
      tags        = v.tags
    } if try(v.private, false) != true
  }

  all_zones = merge(local.private_zones, local.public_zones)
}

module "dns" {
  providers = {
    aws = aws.default
  }
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "~> 3.0"
  create  = true
  zones   = local.all_zones
  tags    = local.all_tags
}

resource "aws_route53_vpc_association_authorization" "vpc_association" {
  provider   = aws.default
  for_each   = local.private_zones
  vpc_id     = var.vpc_id
  vpc_region = var.vpc_region
  zone_id    = module.dns.route53_zone_zone_id[each.key]
}
# module "dns_resolve_rules" {
#   depends_on = [module.dns]
#     providers = {
#         aws = aws.default
#     }
#   source  = "terraform-aws-modules/route53/aws//modules/resolve-rules"
#   version = "~> 3.0"
#
# }