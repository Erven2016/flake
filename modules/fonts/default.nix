{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    mkMerge
    mkDefault
    mkIf
    mkOption
    mkEnableOption
    mkAfter
    types
    ;

  coreFonts = with pkgs; [
    corefonts # Microsoft's TrueType core fonts for the Web
    # font list to display CJK and Emoji fonts.
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-extra
    noto-fonts-emoji
    noto-fonts-color-emoji
    noto-fonts-emoji-blob-bin
  ];

  cfg = config.system.fonts;
in
{

  imports = [ ./nerdfont.nix ];
  options.system.fonts = {
    enable = mkEnableOption "fonts management";

    extraFonts = mkOption {
      type = types.listOf types.package;
      default = [ ];
    };
  };

  config = {

    # 使用桌面时自动启用或手动启用
    fonts = mkIf (config.services.xserver.enable || cfg.enable) {
      enableDefaultPackages = mkDefault true;
      fontDir.enable = mkDefault true;
      enableGhostscriptFonts = mkDefault true;
      packages = mkMerge [
        (coreFonts)
        (cfg.extraFonts)
      ];

      # 默认字体配置
      fontconfig = {
        enable = mkDefault true;
        defaultFonts = {
          emoji = mkAfter [ "Noto Color Emoji" ];
          monospace = mkAfter [
            "BlexMono Nerd Font Mono"
            "FiraCode Nerd Font Mono"
          ];
          serif = mkAfter [
            "Noto Serif"
            "Times New Roman"
          ];
          sansSerif = mkAfter [ "Noto Sans" ];
        };
      };
    };

  };
}
