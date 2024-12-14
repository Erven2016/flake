{
  pkgs,
  lib,
  current,
  ...
}:
let
  inherit (lib) mkDefault mkMerge mkIf;
in
{
  imports = [
    ./boot
    ./sound
    ./fonts
    ./powerManagement
    ./home-manager
    ./nixpkgs
    ./inputMethods
  ];

  config = {

    time.timeZone = current.i18n.timeZone;
    networking.hostName = current.hostname;
    system.stateVersion = current.stateVersion;

    nix = {
      gc = {
        automatic = mkDefault true;
        dates = mkDefault "weekly";
        options = mkDefault "--delete-older-than 60d";
      };
      settings.auto-optimise-store = mkDefault true;
    };

    nixpkgs.config.allowUnfree = current.allowUnfreePackages;

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    services.xserver.excludePackages = mkMerge [ (mkIf (current.desktop != null) [ pkgs.xterm ]) ];

    # Minimal setup
    environment.systemPackages = with pkgs; [
      fontconfig
      nano
      less
      tree

      screen

      btop
      iotop
      iftop
      powertop
      lm_sensors
      ethtool
      pciutils
      usbutils

      fastfetch

      unzip
      zip
      gnutar

      # to enable flake and home-manager
      # wget and git are required
      wget
      curl
      git

      # NixOS
      nix-tree
      nixos-icons

      helix

      #  age encryption tool
      age
    ];
  };
}
