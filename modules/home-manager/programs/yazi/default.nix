{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.home.programs.yazi;
in
{
  options.home.programs.yazi = {
    # 默认关闭
    enable = mkEnableOption "yazi in home-manager";
  };
  config = {
    programs.yazi = {
      enable = mkIf (config.home.programs.zsh.enableYazi || cfg.enable) true;

      # 使用 ya 命令
      enableZshIntegration = config.home.programs.zsh.enableYazi;

      # settings = { };
    };

    home.packages = with pkgs; [
      ueberzugpp # 图像预览所需的库
    ];
  };
}
