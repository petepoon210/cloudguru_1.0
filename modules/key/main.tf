resource "aws_key_pair" "linux-keypair" {
  key_name   = "linux-keypair"
  public_key = var.linux_public_key
}

resource "aws_key_pair" "windows-keypair" {
  key_name   = "windows-keypair"
  public_key = var.windows_public_key
}
