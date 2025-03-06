resource "aws_vpc" "main" {
    cidr_block              = var.vpc_cidr
    enable_dns_hostnames    = true
    enable_dns_support      = true
    tags = var.vpc_tags  
}

resource "aws_subnet" "private" {
    count = length(var.private_cidrs)
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_cidrs[count.index]
    map_public_ip_on_launch = var.map_public_ip_on_launch
    availability_zone = data.aws_availability_zones.az.names[count.index]
    tags = {
        Name = "private-${count.index + 1}"
        "kubernetes.io/role/internal-elb" = 1
        "kubernetes.io/cluster/my-eks-cluster" = "shared"
     }
}

resource "aws_internet_gateway" "igw" {
    count = var.igw ? 1 : 0
    vpc_id  = aws_vpc.main.id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-vpc" {  
  #subnet_ids         = [aws_subnet.private.0.id, aws_subnet.private.1.id]
  subnet_ids = aws_subnet.private.*.id
  transit_gateway_id = var.tgw_id
  vpc_id             = aws_vpc.main.id 
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false  
}

resource "aws_main_route_table_association" "main-rt-vpc" {
  vpc_id         = aws_vpc.main.id
  route_table_id = aws_route_table.private.id  
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id    
    dynamic route {
        for_each = var.private_routes
        content {
            cidr_block = route.value
            transit_gateway_id = var.tgw_id
        }
    }
    depends_on = [aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc]
}

resource "aws_route" "default" {
  count = var.igw ? 1 : 0
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.igw[count.index].id
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_ec2_transit_gateway_route_table_association" "tgw-rt-vpc-assoc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc.id
  transit_gateway_route_table_id = var.tgw_rt_id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw-rt-dev-to-vpc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc.id
  transit_gateway_route_table_id = var.tgw_rt_id
}


