resource "aws_instance" "instance" {
  ami                           = var.ami  
  instance_type                 = var.instance_type
  subnet_id                     = var.subnet_id
  vpc_security_group_ids        = var.vpc_security_group_ids[*]
  key_name                      = var.key_name
  private_ip                    = var.private_ip
  associate_public_ip_address   = var.associate_public_ip_address
  iam_instance_profile          = var.iam_instance_profile
}