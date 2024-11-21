{
  lib,
  current,
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
    enable = mkEnableOption "Rust development environment" // {
      default = current.devenv.rust.enable;
      readOnly = true;
    };

    rustToolchainPackages = mkOption {
      type = types.listOf types.package;
      default = [ pkgs.rustup ];
    };
  };

  config = mkIf cfg.enable { home.packages = mkMerge [ (cfg.rustToolchainPackages) ]; };

}
