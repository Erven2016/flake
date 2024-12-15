let
  pubkey_for_secrets = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHq3sBDoWfcOHn6Z+VcICcKxVrBa7/lYs0//ttjOC5Aj";
in
{
  "password.age".publicKeys = [ pubkey_for_secrets ];
}
