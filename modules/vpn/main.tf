resource "aws_customer_gateway" "cgw" {
  bgp_asn    = var.asn
  ip_address = var.ip_address
  type       = "ipsec.1"

  tags = var.vpn_tags
  
}

resource "aws_vpn_connection" "vc" {
 customer_gateway_id = aws_customer_gateway.cgw.id
 transit_gateway_id  = var.tgw_id
 type                = aws_customer_gateway.cgw.type
}

resource "aws_ec2_transit_gateway_route_table_association" "tgw-rt-vpn-assoc" {
  transit_gateway_attachment_id  = aws_vpn_connection.vc.transit_gateway_attachment_id
  transit_gateway_route_table_id = var.tgw_rt_id

  depends_on = [aws_vpn_connection.vc]
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw-rt-dev-to-vpn" {
  transit_gateway_attachment_id  = aws_vpn_connection.vc.transit_gateway_attachment_id
  transit_gateway_route_table_id = var.tgw_rt_id

  depends_on = [aws_vpn_connection.vc]
}
