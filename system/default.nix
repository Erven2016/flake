{
  current,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkForce mkDefault;
in
{
  imports = [
    ./gnome
    ./fonts
    ./boot
  ];

  config = {
    time.timeZone = current.i18n.timeZone;
    networking.hostName = current.hostname;
    system.stateVersion = current.stateVersion;

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    nix.gc = {
      automatic = mkDefault true;
      dates = mkDefault "weekly";
      options = mkDefault "--delete-older-than 60d";
    };
    nix.settings.auto-optimise-store = mkDefault true;

    nixpkgs.config.allowUnfree = current.allowUnfreePackages;

    programs.zsh.enable = mkDefault true;

    # Minimal setup
    environment.systemPackages = with pkgs; [
      pkg-config
      fontconfig
      nano
      less
      tree

      screen

      htop
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

      wget
      curl
      git

      # NixOS
      nix-tree
      nixos-icons

      helix
      nil

    ];
  };
}
