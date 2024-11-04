{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkDefault mkIf;

  cfg = config.home.programs.zed-editor;
in
{
  options.home.programs.zed-editor = {
    enable = mkEnableOption "zed-editor in home-manager";
    enableUnstableZedEditor = mkEnableOption "using zed-editor of unstable channel";
  };

  config = {
    # 默认选项配置
    home.programs.zed-editor.enableUnstableZedEditor = mkDefault true;

    programs.zed-editor = {
      # 写死，只能由 home.programs.zed-editor.enable 选项控制
      enable = cfg.enable;
      package = mkIf cfg.enableUnstableZedEditor pkgs.unstable.zed-editor;
      userSettings = {
        features = {
          copilot = mkDefault false;
        };
        vim_mode = mkDefault true;
        tab_size = mkDefault 2;
        ui_fonts_size = mkDefault 20;
        buffer_font_size = mkDefault 18;
        proxy = mkDefault "http://localhost:7890";
        theme = {
          mode = mkDefault "system";
          light = mkDefault "One Light";
          dark = mkDefault "One Dark";
        };
      };
    };

    home.packages = with pkgs; [
      nodejs_22
      python3
    ];
  };
}
