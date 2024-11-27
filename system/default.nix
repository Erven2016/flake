{
  current,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    # mkForce
    mkDefault
    mkMerge
    ;
in
{
  imports = [
    ./gnome
    ./sound
    ./fonts
    ./boot
    ./powerManagement
    ./components
  ];

  config = {
    time.timeZone = current.i18n.timeZone;
    networking.hostName = current.hostname;
    system.stateVersion = current.stateVersion;

    nix.gc = {
      automatic = mkDefault true;
      dates = mkDefault "weekly";
      options = mkDefault "--delete-older-than 60d";
    };
    nix.settings.auto-optimise-store = mkDefault true;

    nixpkgs.config.allowUnfree = current.allowUnfreePackages;

    programs.zsh.enable = mkDefault true;

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    services.xserver.excludePackages = mkMerge [ (mkIf (current.desktop != null) [ pkgs.xterm ]) ];

    # Minimal setup
    environment.systemPackages = with pkgs; [
      pkg-config
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
      nil
    ];
  };
}
