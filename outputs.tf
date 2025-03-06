output "vpc1_id" {
    value = module.VPC["vpc1"].vpc_id
}

output "vpc1_subnet1_id" {
    value = module.VPC["vpc1"].subnet_ids[0]
}

output "vpc1_subnet2_id" {
    value = module.VPC["vpc1"].subnet_ids[1]
}

output "vpc1_ec2_1_intance_id" {
    value = module.EC2_LINUX["ec2_1"].aws_ec2_instance_id
}
