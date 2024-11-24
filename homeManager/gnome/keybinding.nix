{ lib, current, ... }:
let
  inherit (lib) mkOption mkIf;
in
{
  options.home.gnome.keybindings = mkOption {
    # type example:
    # [
    #   {
    #     name = "Open Terminal";
    #     command = "terminal";
    #     binding = "<Super>t";
    #   }
    # ]
  };

  config = mkIf (current.desktop == "gnome") { };
}
