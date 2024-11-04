{ lib, pkgs, ... }:
let
  inherit (lib) mkMerge;
in
{
  config = {

    environment.systemPackages = mkMerge [
      (with pkgs; [
        pkg-config
        nano
      ])

      (with pkgs; [
        btop
        htop
        iftop
        iotop
        bottom

        # hardware info & check
        powertop
        lm_sensors
        ethtool
        pciutils
        usbutils
        fastfetch

        # file compressing tools
        unzip
        zip
        gnutar

        # http request tools
        wget
        curl

        # other tools
        git
        less

        # NixOS
        nixos-icons

        nix-tree

        fontconfig
        screen
      ])
    ];

    # Z SHELL (ZSH)
    # users.defaultUserShell = pkgs.zsh;
    # environment.shells = with pkgs; [ zsh ];
    programs.zsh.enable = true;
  };
}
