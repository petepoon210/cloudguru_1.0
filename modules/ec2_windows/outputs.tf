output "aws_ec2_instance_id" {
  value = aws_instance.instance.id
}

output "aws_ec2_instance_public_ip" {
  value = aws_instance.instance.public_ip
}