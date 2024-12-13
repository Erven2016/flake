{
  inputs,
  lib,
  current,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  imports = [ inputs.nixos-cosmic.nixosModules.default ];
  config = mkIf (current.desktop == "cosmic") {
    nix.settings = {
      substituters = [ "https://cosmic.cachix.org/" ];
      trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
    };

    xdg.portal.enable = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

    services.desktopManager.cosmic.enable = true;
    services.displayManager.cosmic-greeter.enable = true;
  };
}
