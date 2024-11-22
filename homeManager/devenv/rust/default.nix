{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    types
    mkOption
    mkMerge
    ;

  cfg = config.home.devenv.rust;
in
{
  options.home.devenv.rust = {
    enable = mkEnableOption "Rust development environment";

    rustToolchainPackages = mkOption {
      type = types.listOf types.package;
      default = [ pkgs.rustup ];
    };
  };

  config = mkIf cfg.enable { home.packages = mkMerge [ (cfg.rustToolchainPackages) ]; };

}
