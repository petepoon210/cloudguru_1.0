resource "aws_ec2_transit_gateway" "tgw" {
  #count = var.tgw ? 1 : 0  
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
}

resource "aws_ec2_transit_gateway_route_table" "tgw-dev-rt" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
}


# resource "aws_route_table" "private" {
#     vpc_id = aws_vpc.main.id    
#     dynamic route {
#         for_each = var.private_routes
#         content {
#             cidr_block = route.value
#             transit_gateway_id = aws_ec2_transit_gateway.tgw.id
#         }
#     }
# }

# resource "aws_main_route_table_association" "main-rt-vpc" {
#   vpc_id         = "${aws_vpc.vpc-1.id}"
#   route_table_id = "${aws_route_table.vpc-1-rtb.id}"
# }


