# https://nixos.wiki/wiki/WayDroid
{ current, lib, ... }:
let
  inherit (lib) mkIf;
in
{
  config = mkIf current.components.waydroid.enable {
    # enable waydroid
    virtualisation.waydroid.enable = true;
  };
}
