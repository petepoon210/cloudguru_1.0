resource "aws_vpc_endpoint" "this" {
  vpc_id               = var.vpc_id
  subnet_ids           = var.subnet_id

  for_each = var.vpc_endpoints
  service_name         = "com.amazonaws.${each.value.region}.${each.key}"
  vpc_endpoint_type    = each.value.endpoints[each.key].vpc_endpoint_type
  security_group_ids   = [
    each.value.rdp_access_id,
    each.value.http_access_id
  ]
  private_dns_enabled  = each.value.endpoints[each.key].private_dns_enabled
  ip_address_type      = each.value.endpoints[each.key].ip_address_type
}