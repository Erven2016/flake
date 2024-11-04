# 命令行提示表
# 默认快捷键: Ctrl+g
{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkDefault mkEnableOption;

  cfg = config.home.programs.navi;
in
{
  options.home.programs.navi = {
    enable = mkEnableOption "navi in home-manager";
  };

  config = {
    programs.navi = {
      enable = mkIf (cfg.enable || config.home.programs.zsh.enableNavi) true;
      enableZshIntegration = mkIf config.home.programs.zsh.enableNavi true;
    };

    # Extra packages
    home.packages = mkIf config.programs.navi.enable (with pkgs; [ fzf ]);
  };
}
