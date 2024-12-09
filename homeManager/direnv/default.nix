{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableDefault mkIf mkForce;

  cfg = config.home.programs.direnv;
in
{
  options.home.programs.direnv = {
    enable = mkEnableDefault "direnv";
  };

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = mkForce true;
      enableZshIntegration = mkForce true;
    };
  };
}
