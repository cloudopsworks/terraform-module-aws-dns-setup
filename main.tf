##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

module "dns" {
  providers = {
    aws = aws.default
  }
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "~> 3.0"

  create = true
  zones  = var.zones
  tags   = local.all_tags
}