{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkDefault mkIf;

  cfg = config.home.programs.git;
in
{
  options.home.programs.git = {
    enable = mkEnableOption "git in home-manager" // {
      default = true;
    };

    enableLazygit = mkEnableOption "lazygit in home-manager" // {
      default = true;
    };
  };

  config.programs.git = {
    enable = cfg.enable;
    extraConfig = mkDefault {
      init = {
        defaultBranch = "main";
      };
    };
  };

  config.programs.lazygit = mkIf cfg.enable { enable = cfg.enableLazygit; };
}
