{ pkgs, ... }:
{
  imports = [
    # hardware-configuration.nix 是 NixOS 自动生成的
    # 如果必要，不要去修改它。
    /etc/nixos/hardware-configuration.nix

    ./modules
  ];

  system.stateVersion = "24.05";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # garbage collection
  # remove unused derivation automatically.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 60d";
  };

  # [optimise storage]
  # --------------------
  # you can also optimise the store manually via:
  #    nix-store --optimise
  # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
  nix.settings.auto-optimise-store = true;

  nixpkgs.config.allowUnfree = true;

  programs.clash-verge = {
    enable = true;
    autoStart = true;
    package = pkgs.clash-verge-rev;
  };
}
