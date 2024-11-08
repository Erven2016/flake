{ pkgs, ... }:
{
  users.users = {
    erven2016 = {
      isNormalUser = true;
      extraGroups = [
        "docker"
        "wheel"
        "networkmanager"
        "libvirtd"
      ];
      shell = pkgs.zsh;
    };
  };

  networking.proxy.allProxy = "http://127.0.0.1:7890";

  home-manager.users.erven2016 = {

    imports = [ ../home.nix ];

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "24.05";

    home.username = "erven2016";
    home.homeDirectory = "/home/erven2016";

    # Custom packages
    home.packages = with pkgs; [
      lazygit

      dust
      dua

      unstable.zed-editor
    ];

    programs.helix.enable = true; # todo
    home.programs.zsh.enable = true;
    # home.programs.zed-editor.enable = true;

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    # Custom
    programs.zellij.enable = true;

    # git config
    programs.git = {
      enable = true;
      userName = "Erven2016";
      userEmail = "leiguihua2016@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
      };
    };
  };
}
