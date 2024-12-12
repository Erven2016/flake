{
  imports = [
    ./gnome
    ./zed-editor
  ];

  # Custom programs' options
  home.programs = {
    joshuto.enable = true;
    zed-editor.enable = true;
    direnv.enable = true;
  };

  # Home-manager programs' options
  programs.zsh.oh-my-zsh.plugins = [ "rust" ];
  programs.git.extraConfig = {
    user = {
      email = "leiguihua2016@gmail.com";
      name = "erven2016";
    };
  };
}
