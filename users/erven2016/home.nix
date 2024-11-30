{
  # current,
  # pkgs,
  # lib,
  ...
}:
# let
#   inherit (lib) mkDefault;
# in
{

  imports = [ ./gnome ];

  # home.packages = with pkgs; [ ];

  home.programs.zsh.enable = true;
  home.programs.joshuto.enable = true;
  home.programs.zed-editor.enable = true;
  programs.zsh.oh-my-zsh.plugins = [ "rust" ];

  home.devenv = {
    enable = true;

    go = {
      enable = true;
    };

    rust = {
      enable = true;
    };

    nodejs = {
      enable = true;
    };

    python = {
      enable = true;
    };
  };
}
