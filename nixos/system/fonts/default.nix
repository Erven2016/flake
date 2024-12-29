{
  lib,
  pkgs,
  current,
  ...
}:
let
  inherit (lib)
    mkMerge
    mkIf
    mkDefault
    mkAfter
    ;
in
{

  imports = [ ./nerdfonts.nix ];

  # NOTE: only enable fonts in GUI enviroment
  config = mkIf (current.desktop != null) {
    fonts = {
      enableDefaultPackages = mkDefault true;
      fontDir.enable = mkDefault true;
      enableGhostscriptFonts = mkDefault false;

      packages = mkMerge [
        (with pkgs; [
          corefonts # Microsoft's TrueType core fonts for the Web

          # installing noto-cjk fonts to display CJK
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif
          noto-fonts-extra
          noto-fonts-emoji
          noto-fonts-color-emoji
          noto-fonts-emoji-blob-bin
        ])
      ];

      # Default font-config
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
