# Option scope: users.users.<username>.
{ pkgs, ... }:
{
  extraGroups = [ ];
  # default shell
  shell = pkgs.fish;

  # packages = with pkgs; [ ];
}
