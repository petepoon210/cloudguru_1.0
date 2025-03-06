resource "aws_vpc_endpoint" "ssm_ssm_endpoint" {
  for_each             = var.vpc
  vpc_id               = module.VPC[each.value.name].vpc_id  # Use the VPC module output for each unique VPC
  service_name         = "com.amazonaws.${var.region}.ssm"  # Example for SSM service; repeat for each service
  vpc_endpoint_type    = "Interface"
  security_group_ids   = [module.rdp_access[each.value.name].security_group_id, module.http_access[each.value.name].security_group_id]
  private_dns_enabled  = true
  ip_address_type      = "ipv4"
  subnet_ids           = [for i in range(length(each.value.private_cidrs)) : module.VPC[each.value.name].subnet_ids[i]]
}

resource "aws_vpc_endpoint" "ssm_ec2messages_endpoint" {
  for_each             = var.vpc
  vpc_id               = module.VPC[each.value.name].vpc_id  # Use the VPC module output for each unique VPC
  service_name         = "com.amazonaws.${var.region}.ec2messages"  # Example for SSM service; repeat for each service
  vpc_endpoint_type    = "Interface"
  security_group_ids   = [module.rdp_access[each.value.name].security_group_id, module.http_access[each.value.name].security_group_id]
  private_dns_enabled  = true
  ip_address_type      = "ipv4"
  subnet_ids           = [for i in range(length(each.value.private_cidrs)) : module.VPC[each.value.name].subnet_ids[i]]
}

resource "aws_vpc_endpoint" "ssm_ssmmessages_endpoint" {
  for_each             = var.vpc
  vpc_id               = module.VPC[each.value.name].vpc_id  # Use the VPC module output for each unique VPC
  service_name         = "com.amazonaws.${var.region}.ssmmessages"  # Example for SSM service; repeat for each service
  vpc_endpoint_type    = "Interface"
  security_group_ids   = [module.rdp_access[each.value.name].security_group_id, module.http_access[each.value.name].security_group_id]
  private_dns_enabled  = true
  ip_address_type      = "ipv4"
  subnet_ids           = [for i in range(length(each.value.private_cidrs)) : module.VPC[each.value.name].subnet_ids[i]]
}

resource "aws_iam_role" "ssm_role" {
  name = "SSMRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "SSMInstanceProfile"
  role = aws_iam_role.ssm_role.name
}