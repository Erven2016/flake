{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf mkForce;

  cfg = config.home.programs.direnv;
in
{
  options.home.programs.direnv = {
    enable = mkEnableOption "direnv";
  };

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = mkForce true;
      enableZshIntegration = mkForce true;

      nix-direnv.enable = true;
    };
  };
}
