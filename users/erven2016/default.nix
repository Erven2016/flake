{ pkgs, ... }:
{

  isNormalUser = true;
  extraGroups = [
    "docker"
    "wheel"
    "networkmanager"
  ];
  shell = pkgs.zsh;
  packages = with pkgs; [
    zsh

    dust # better `du`

    unstable.flatpak-builder
    unstable.appstream
  ];

}
