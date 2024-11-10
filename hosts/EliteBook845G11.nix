{
  lib,
  pkgs,
  meta,
  ...
}:
let
  inherit (lib) mkMerge;
in
{
  config = {
    networking.hostName = meta.hostname;
    # 设置时区
    time.timeZone = "Asia/Taipei";

    system.flatpak = {
      enable = true;
      enableDevTools = true;
    };

    system.kvm.enable = true;
    system.kernel.enableLatestKernel = false;

    system.devel.rust.enable = true;
    system.devel.nodejs.enable = true;

    system = {
      desktop.gnome = {
        enableGnomeTerminal = true;
        excludePackages = with pkgs; [
          # clean up useless gnome apps
          gnome-tour
          # to use warehouse to manage flatpak applications instead of gnome software
          # running in shell: `flatpak install flathub io.github.flattool.Warehouse`
          gnome.gnome-software
        ];
        extraExtensions = with pkgs.gnomeExtensions; [
          auto-activities
          gnome-40-ui-improvements
          alphabetical-app-grid
          luminus-shell-y
          blur-my-shell
          wtmb-window-thumbnails
        ];
      };
    };

    # Custom-packages list
    environment.systemPackages = mkMerge [
      (with pkgs; [
        amdgpu_top
        libheif
        rustup
        gcc

        unstable.devenv

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

    # to enable fingerprint sensor
    services.fwupd.enable = true;
    services.fprintd = {
      enable = true;
    };
  };
}
