output "linux_keypair_id" {
  value = aws_key_pair.linux-keypair.id
}

output "windows_keypair_id" {
  value = aws_key_pair.windows-keypair.id
}