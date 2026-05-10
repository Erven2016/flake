{ pkgs, config, ... }:
{
  config = {
    services.flatpak.enable = true;

    # To fix font and cursor missing that flatpak applications
    # https://nixos.wiki/wiki/Fonts#Flatpak_applications_can.27t_find_system_fonts
    system.fsPackages = [ pkgs.bindfs ];
    fileSystems =
      let
        mkRoSymBind = path: {
          device = path;
          fsType = "fuse.bindfs";
          options = [
            "ro"
            "resolve-symlinks"
            "x-gvfs-hide"
          ];
        };
        aggregatedIcons = pkgs.buildEnv {
          name = "system-icons";
          paths = with pkgs; [
            #libsForQt5.breeze-qt5  # for plasma
            gnome-themes-extra
          ];
          pathsToLink = [ "/share/icons" ];
        };
        aggregatedFonts = pkgs.buildEnv {
          name = "system-fonts";
          paths = config.fonts.packages;
          pathsToLink = [ "/share/fonts" ];
        };
      in
      {
        "/usr/share/icons" = mkRoSymBind "${aggregatedIcons}/share/icons";
        "/usr/local/share/fonts" = mkRoSymBind "${aggregatedFonts}/share/fonts";
      };

    fonts = {
      fontDir.enable = true;
      packages = with pkgs; [
        noto-fonts
        noto-fonts-color-emoji
        noto-fonts-cjk-sans
      ];
    };
  };
}
