{
  lib,
  current,
  pkgs,
  ...
}:
let
  inherit (lib) mkMerge mkIf;
in
{
  # should only support for GTK-based desktops
  config = mkIf (current.desktop == "gnome") {
    i18n.inputMethod = {
      enable = true;
      type = "ibus";
      ibus.engines = mkMerge [
        (mkIf (
          (builtins.elem "zh_CN.UTF-8/UTF-8" current.i18n.supportedLocales)
          || (builtins.elem "zh_TW.UTF-8/UTF-8" current.i18n.supportedLocales)
        ) [ pkgs.ibus-engines.libpinyin ])
      ];
    };
  };
}
