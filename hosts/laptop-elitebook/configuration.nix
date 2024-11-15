{ pkgs, config, ... }:
{
  imports = [ ./hardware-configuration.nix ];
  config = {
    networking.networkmanager.enable = true;
    programs.proxychains = {
      enable = true;
      proxies.prx1 = {
        enable = true;
        type = "socks5";
        host = "127.0.0.1";
        port = 7890;
      };
    };

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    services.flatpak.enable = true;
    xdg.portal.enable = true;

    networking.proxy.allProxy = "http://127.0.0.1:7890";

    programs.clash-verge = {
      enable = true;
      autoStart = true;
      package = pkgs.clash-verge-rev;
    };

    hardware.opengl = {
      ## radv: an open-source Vulkan driver from freedesktop
      driSupport = true;
      driSupport32Bit = true;

      ## amdvlk: an open-source Vulkan driver from AMD
      extraPackages = [ pkgs.amdvlk ];
      extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
    };

    # hardware.steam-hardware.enable = true;

    # to enable fingerprint sensor
    services.fwupd.enable = true;
    services.fprintd = {
      enable = true;
    };

    # 修复 Flatpak 应用不能发现系统环境中的字体
    # todo: 按需启用对应的 system-icons
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
            #libsForQt5.breeze-qt5  # for Plasma
            gnome.gnome-themes-extra # for Gnome
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

    # boot.kernelParams = [
    #   "video=eDP-1:2560x1600@120"
    #   "video=HDMI-A-1:d"
    #   "video=DP-1:d"
    #   "video=DP-2:d"
    #   "video=DP-3:d"
    #   "video=DP-4:d"
    #   "video=DP-5:d"
    #   "video=DP-6:d"
    #   "video=DP-7:d"
    # ];
  };
}
