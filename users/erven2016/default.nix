{ pkgs, ... }:
{

  isNormalUser = true;
  extraGroups = [
    "docker"
    "wheel"
    "networkmanager"
    "libvirtd"
  ];
  shell = pkgs.zsh;
  packages = with pkgs; [
    zsh
  ];

}
