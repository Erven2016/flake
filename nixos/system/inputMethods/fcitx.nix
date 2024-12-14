{
  pkgs,
  current,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  config = mkIf (current.desktop == "kde") {
    i18n.inputMethod = {
      type = "fcitx5";
      enable = true;
      fcitx5.addons = with pkgs; [
        rime-data
        fcitx5-rime
        fcitx5-lua
        fcitx5-fluent
        fcitx5-chinese-addons
        fcitx5-gtk
      ];
    };
  };
}
