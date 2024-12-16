{ pkgs, superConfig, ... }:
{
  extraGroups = [
    "wheel"
    "networkmanager"
  ];
  shell = pkgs.fish;

  packages = with pkgs; [
    dust # better `du`
    unstable.flatpak-builder
    unstable.appstream
  ];

  # password = "1234567890";
  hashedPasswordFile = superConfig.age.secrets.erven2016_password.path;

}
