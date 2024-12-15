{ pkgs, ... }:
{
  password = 1234567890;
  extraGroups = [
    "wheel"
    "networkmanager"
  ];
  shell = pkgs.fish;
}
