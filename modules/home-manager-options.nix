# home-manager 共用配置
{ lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  config = {
    home-manager.useGlobalPkgs = mkDefault true;
    home-manager.useUserPackages = mkDefault true;

    # Optionally, use home-manager.extraSpecialArgs to pass arguments
  };

}
