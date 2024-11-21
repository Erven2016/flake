{
  lib,
  config,
  pkgs,
  current,
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
    enable = mkEnableOption "NodeJS" // {
      readOnly = true;
      default = current.devenv.nodejs.enable;
    };

    # default nodejs version which will be used
    package = mkOption {
      type = types.package;
      default = pkgs.nodejs_23;
    };

  };

  config = mkIf cfg.enable {
    home.packages = mkMerge [
      [ (cfg.package) ]

      (with pkgs.nodePackages_latest; [ nrm ])
    ];

  };
}
