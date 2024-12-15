{
  current,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  imports = [ ./erven2016 ];
  config = mkIf (current.hasTag "agenix") {
    environment.systemPackages = [ inputs.agenix.packages.${current.architecture}.default ];

    age.identityPaths = [ "/persistent/home/erven2016/.ssh" ];
  };
}
