{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    mkMerge
    ;

  cfg = config.system.devel.rust;
in
{
  options.system.devel.rust = {
    enable = mkEnableOption "rust development toolchains";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = mkMerge [
      (with pkgs; [
        rustup
        gcc
      ])
    ];

    environment.sessionVariables = rec {
      CARGO_HOME = "$HOME/.cargo"; # default cargo local caches and crates
      PATH = [ "${CARGO_HOME}/bin" ];
    };
  };
}
