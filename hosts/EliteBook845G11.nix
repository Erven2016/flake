{ lib, pkgs, ... }:
let
  inherit (lib) mkMerge;
in
{
  config = {
    networking.hostName = "EliteBook845G11";
    # 设置时区
    time.timeZone = "Asia/Taipei";

    system.flatpak.enable = true;
    system.kvm.enable = true;

    system.devel.rust.enable = true;

    # Custom-packages list
    environment.systemPackages = mkMerge [
      (with pkgs; [
        amdgpu_top
        libheif
        rustup
        gcc

        # required by zed nix extension
        nixd
        nixpkgs-fmt
      ])

      (with pkgs.dynamic-gnome-wallpapers; [
        macos-sonoma
        macos-ventura
        macos-sequoia
        moon-far-view
        win11-bloom-ventura
        win11-bloom-gradient
      ])
    ];

    # Fonts
    system.fonts.extraFonts = with pkgs; [
      wqy_microhei
      wqy_zenhei
      source-han-sans
      source-han-serif
      roboto

      vegur

      nur-erven2016.otf-pingfang
      nur-erven2016.otf-sf-pro
    ];
    system.fonts.extraNerdFonts = [ "JetBrainsMono" ];
    fonts.fontconfig.defaultFonts = {
      sansSerif = [ "PingFang SC" ];
      serif = [ "PingFang SC" ];
    };

    networking.networkmanager.enable = true;

    # ProxyChains
    programs.proxychains = {
      enable = true;
      proxies.prx1 = {
        enable = true;
        type = "socks5";
        host = "127.0.0.1";
        port = 7890;
      };
    };

    programs.appimage = {
      enable = true;
      binfmt = true;
    };

    i18n = {
      defaultLocale = "en_US.UTF-8";
      supportedLocales = [
        "en_US.UTF-8/UTF-8"
        "zh_CN.UTF-8/UTF-8"
      ];
      inputMethod = {
        enabled = "ibus";
        ibus.engines = with pkgs.ibus-engines; [
          libpinyin
          # rime # disable it because librime-lua is under unstable now.
        ];
      };
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

    services.fwupd.enable = true;
    services.fprintd = {
      enable = true;
    };
  };
}
