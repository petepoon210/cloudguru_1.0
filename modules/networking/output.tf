output "vpc_id" {
    value = aws_vpc.main.id
}

output "subnet_ids" {
    value = aws_subnet.private.*.id
}

output "route_table_ids" {
    value = aws_route_table.private.id
}