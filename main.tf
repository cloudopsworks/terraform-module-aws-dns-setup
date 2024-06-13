##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

locals {
  private_zones = {
    for k, v in var.zones : k => {
      domain_name = k
      comment     = v.comment
      tags        = v.tags
      vpc = {
        vpc_id = var.vpc_id
      }
    } if try(v.private, false) == true
  }
  public_zones = {
    for k, v in var.zones : k => {
      domain_name = k
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

# module "dns_resolve_rules" {
#   depends_on = [module.dns]
#     providers = {
#         aws = aws.default
#     }
#   source  = "terraform-aws-modules/route53/aws//modules/resolve-rules"
#   version = "~> 3.0"
#
# }