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
    mkOption
    types
    ;

  cfg = config.home.programs.joshuto;
in
{
  options.home.programs.joshuto = {
    enable = mkEnableOption "joshuto";

    integrationKeybind = mkOption {
      type = types.str;
      description = "keys to open joshuto, defaultly are `Alt`-`e`";
      default = "^[e"; # Alt-e
    };

    enableUnstableVersion = mkEnableOption "joshotu version of nixpkgs-unstable";
  };

  config = mkIf cfg.enable {
    programs.joshuto = {
      enable = cfg.enable;
      package = mkIf (cfg.enableUnstableVersion) pkgs.unstable.joshuto;
    };
  };
}
