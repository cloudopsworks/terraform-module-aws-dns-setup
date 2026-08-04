##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

output "zones" {
  description = "Map of every Route53 hosted zone created by this module (public and private), keyed by domain name. Each entry exposes the zone id, ARN, name and delegated name servers."
  value = {
    for v in aws_route53_zone.this :
    v.name => {
      id           = v.zone_id
      arn          = v.arn
      name         = v.name
      name_servers = v.name_servers
    }
  }
}

output "resolver_rules" {
  description = "Route53 Resolver FORWARD rules generated for the private zones hosted by this hub, keyed by rule name under the `inbound` key. Empty when `is_hub` is false."
  value = {
    inbound = {
      for rr in aws_route53_resolver_rule.inbound_rules :
      rr.name => {
        id                   = rr.id
        arn                  = rr.arn
        domain_name          = rr.domain_name
        rule_type            = rr.rule_type
        resolver_endpoint_id = rr.resolver_endpoint_id
        target_ip            = rr.target_ip
      }
    }
  }
}

output "custom_resolver_rules" {
  description = "Route53 Resolver rules built from `custom_resolver_rules`, keyed by rule name under the `inbound` key. Empty when `is_hub` is false."
  value = {
    inbound = {
      for rr in aws_route53_resolver_rule.custom_inbound_rules :
      rr.name => {
        id                   = rr.id
        arn                  = rr.arn
        domain_name          = rr.domain_name
        rule_type            = rr.rule_type
        resolver_endpoint_id = rr.resolver_endpoint_id
        target_ip            = rr.target_ip
      }
    }
  }
}

output "resolver_rules_associations" {
  description = "Associations between the resolver rules shared from the hub (`shared.resolver_rules`) and this account's VPC, keyed by association name. Populated on spoke deployments."
  value = {
    for rra in aws_route53_resolver_rule_association.inbound_rules :
    rra.name => {
      id               = rra.id
      resolver_rule_id = rra.resolver_rule_id
      vpc_id           = rra.vpc_id
    }
  }
}

output "resolver_endpoints" {
  description = "Inbound and outbound Route53 Resolver endpoints created on the hub, including their ids, ARNs, host VPC, security groups and IP addresses. Both keys are null when `is_hub` is false."
  value = {
    inbound = var.is_hub ? {
      (module.resolver_endpoint_in.id) = {
        id                  = module.resolver_endpoint_in.id
        arn                 = module.resolver_endpoint_in.arn
        host_vpc_id         = module.resolver_endpoint_in.host_vpc_id
        security_groups_ids = module.resolver_endpoint_in.security_group_ids
        ip_addresses        = module.resolver_endpoint_in.ip_addresses
      }
    } : null
    outbound = var.is_hub ? {
      (module.resolver_endpoint_out.id) = {
        id                  = module.resolver_endpoint_out.id
        arn                 = module.resolver_endpoint_out.arn
        host_vpc_id         = module.resolver_endpoint_out.host_vpc_id
        security_groups_ids = module.resolver_endpoint_out.security_group_ids
        ip_addresses        = module.resolver_endpoint_out.ip_addresses
      }
    } : null
  }
}

output "ram" {
  description = "AWS RAM sharing state for the resolver rules exported by this hub: resource shares, resource associations and principal associations for both zone-derived and custom rules. Consumed by spoke deployments through their `shared` variable."
  value = {
    custom_rules_resource_shares = {
      for rs in aws_ram_resource_share.custom_inbound_rules :
      rs.name => {
        id                        = rs.id
        arn                       = rs.arn
        allow_external_principals = rs.allow_external_principals
      }
    }
    custom_rules_principal_associations = {
      for pa in aws_ram_principal_association.custom_inbound_rules :
      pa.id => {
        principal          = pa.principal
        resource_share_arn = pa.resource_share_arn
      }
    }
    resource_shares = {
      for rs in aws_ram_resource_share.inbound_rules :
      rs.name => {
        id                        = rs.id
        arn                       = rs.arn
        allow_external_principals = rs.allow_external_principals
      }
    }
    resource_associations = {
      for ra in aws_ram_resource_association.inbound_rules :
      ra.id => {
        resource_arn       = ra.resource_arn
        resource_share_arn = ra.resource_share_arn
      }
    }
    principal_associations = {
      for pa in aws_ram_principal_association.inbound_rules :
      pa.id => {
        principal          = pa.principal
        resource_share_arn = pa.resource_share_arn
      }
    }
  }
}

output "dns_vpc" {
  description = "Networking context the DNS resources were deployed into: VPC id, the region resolved from the provider, VPC CIDR block and the subnets used for the resolver ENIs."
  value = {
    vpc_id         = var.vpc_id
    vpc_region     = data.aws_region.current.id
    vpc_cidr_block = var.vpc_cidr_block
    subnet_ids     = var.subnet_ids
  }
}

output "vpc_association_auth" {
  description = "Cross-account VPC association authorizations issued for each private zone, keyed by zone key. Only populated when `dns_vpc.vpc_id` is set; the authorized account must complete the association on its side."
  value = {
    for k, v in local.private_zones :
    k => {
      id         = aws_route53_vpc_association_authorization.vpc_association[k].id
      zone_id    = aws_route53_vpc_association_authorization.vpc_association[k].zone_id
      vpc_id     = aws_route53_vpc_association_authorization.vpc_association[k].vpc_id
      vpc_region = aws_route53_vpc_association_authorization.vpc_association[k].vpc_region
    }
    if var.dns_vpc.vpc_id != ""
  }
}