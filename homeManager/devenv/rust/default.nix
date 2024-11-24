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

    installBy = mkOption {
      type = types.enum [ "nixpkgs" ];
      default = "nixpkgs";
    };

  };

  config = mkIf cfg.enable {
    home.packages = mkMerge [
      (mkIf (cfg.installBy == "nixpkgs") (
        with pkgs;
        [
          unstable.cargo
          unstable.rustc
          unstable.rust-analyzer
        ]
      ))
    ];
  };

}
