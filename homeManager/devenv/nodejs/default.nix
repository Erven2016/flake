{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    types
    ;

  cfg = config.home.devenv.nodejs;
in
{
  options.home.devenv.nodejs = {
    enable = mkEnableOption "NodeJS";

    # default nodejs version which will be used
    package = mkOption {
      type = types.package;
      default = pkgs.nodejs_20;
    };

  };

  config = mkIf cfg.enable {
    home.packages = mkMerge [
      [ (cfg.package) ]

      (with pkgs.nodePackages_latest; [ nrm ])
    ];

  };
}
