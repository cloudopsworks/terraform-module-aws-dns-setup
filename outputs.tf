##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

output "zones" {
  value = {
    for k, v in module.dns.route53_static_zone_name :
    k => {
      id           = module.dns.route53_zone_zone_id[k]
      arn          = module.dns.route53_zone_zone_arn[k]
      name         = module.dns.route53_zone_name[k]
      name_servers = module.dns.route53_zone_name_servers[k]
    }
  }
}

output "resolver_rules" {
  value = {
    outbound = {
      for rr in aws_route53_resolver_rule.outbound_rules :
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

output "resolver_endpoints" {
  value = {
    inbound = {
      for re in module.resolver_endpoint_in :
      re.name => {
        id                  = re.route53_resolver_endpoint_id
        arn                 = re.route53_resolver_endpoint_arn
        host_vpc_id         = re.route53_resolver_endpoint_host_vpc_id
        security_groups_ids = re.route53_resolver_endpoint_security_group_ids
        ip_addresses        = re.route53_resolver_endpoint_ip_addresses
      }
    }
    outbound = {
      for re in module.resolver_endpoint_out :
      re.name => {
        id                  = re.route53_resolver_endpoint_id
        arn                 = re.route53_resolver_endpoint_arn
        host_vpc_id         = re.route53_resolver_endpoint_host_vpc_id
        security_groups_ids = re.route53_resolver_endpoint_security_group_ids
        ip_addresses        = re.route53_resolver_endpoint_ip_addresses
      }
    }
  }
}

output "ram" {
  value = {
    resource_shares = {
      for rs in aws_ram_resource_share.outbound_rules :
      rs.name => {
        id                        = rs.id
        arn                       = rs.arn
        allow_external_principals = rs.allow_external_principals
      }
    }
    resource_associations = {
      for ra in aws_ram_resource_association.outbound_rules :
      ra.id => {
        resource_arn       = ra.resource_arn
        resource_share_arn = ra.resource_share_arn
      }
    }
    principal_associations = {
      for pa in aws_ram_principal_association.outbound_rules :
      pa.id => {
        principal          = pa.principal
        resource_share_arn = pa.resource_share_arn
      }
    }
  }
}