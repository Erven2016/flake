{ pkgs
, ...
}:
let
  sshkey_pub_1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII71S2JhmnuH98PfzuRBWLBATn89mwLYVcBheGbSTTvJ leiguihua2016@gmail.com";
in
{
  environment.systemPackages = [ pkgs.agenix ];
}
