output "tgw_id" {
    value = aws_ec2_transit_gateway.tgw.id
}

output "tgw_rt_id" {
    value = aws_ec2_transit_gateway_route_table.tgw-dev-rt.id
}
