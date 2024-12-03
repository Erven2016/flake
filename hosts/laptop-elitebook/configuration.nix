{
  pkgs,
  # config,
  inputs,
  ...
}:
let
  nixos-hardware = inputs.nixos-hardware;
in
{
  imports = [
    ./hardware-configuration.nix

    # nixos-hardware
    nixos-hardware.nixosModules.common-cpu-amd
  ];

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

    fonts.packages = with pkgs; [
      erven2016.fonts.otf-pingfang
      lxgw-wenkai-tc
      lxgw-wenkai-screen
      lxgw-wenkai
    ];
    fonts.fontconfig.defaultFonts.sansSerif = [
      "PingFang SC"
      "PingFang TC"
      "PingFang HK"
    ];

    networking.proxy.allProxy = "http://127.0.0.1:7890";

    programs.clash-verge = {
      enable = true;
      autoStart = true;
      package = pkgs.clash-verge-rev;
    };

    hardware.graphics = {
      ## radv: an open-source Vulkan driver from freedesktop
      enable = true;
      enable32Bit = true;

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

    # environment.systemPackages = with pkgs; [ ];

    environment.sessionVariables = {
      # to fix black border of some gnome applications
      # see: https://gitlab.gnome.org/GNOME/gtk/-/issues/6890
      GSK_RENDERER = "gl";
    };

    environment.gnome.excludePackages = with pkgs; [
      gnome-software # using warehouse instead
      gnome-weather
      gnome-tour
      gnome-user-docs
      gnome-maps
      gnome-music # replaced with gapless
      gnome-text-editor # replaced with helix
    ];
  };
}
