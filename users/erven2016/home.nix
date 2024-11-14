{
  current,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkDefault;
in
{
  home.packages = with pkgs; [ unstable.zed-editor ];

  home.programs.zsh.enable = true;
  programs.zsh.oh-my-zsh.plugins = [ "rust" ];
}
