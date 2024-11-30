{
  # current,
  pkgs,
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

  programs.git.extraConfig = {
    user = {
      email = "leiguihua2016@gmail.com";
      name = "erven2016";
    };
  };
}
