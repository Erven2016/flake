# https://nixos.wiki/wiki/WayDroid
{ current, lib, ... }:
let
  inherit (lib) mkIf;
in
{
  config = mkIf current.components.waydorid.enable {
    # enable waydroid
    virtualisation.waydroid.enable = true;
  };
}
