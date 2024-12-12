{
  lib,
  current,
  pkgs,
  ...
}:
let
  inherit (lib) mkMerge mkIf mkDefault;
in
{
  imports = [
    ./_system
    ./_home
    ./_nixpkgs

    ./gnome/_system.nix
    ./components/_system.nix
  ];

  config = {
    # instantiate users
    users.users = lib.genAttrs current.users (
      username:
      { config, ... }:
      mkMerge [
        (import ../users/${username} { inherit lib pkgs; })
        ({
          extraGroups = mkMerge [
            (mkIf (builtins.elem username current.components.kvm.allowUsers) [ "libvirtd" ])
          ];
        })
        ({
          isNormalUser = true;

          shell = mkDefault pkgs.bash; # set default shell
          ignoreShellProgramCheck = true;
          packages = [ config.shell ];
        })
      ]
    );

    # Home-manager User Options
    home-manager.users = lib.genAttrs current.users (
      username:
      (mkMerge [
        {
          # Set stateVersion
          home.stateVersion = current.stateVersion;
        }

        # import home-mananger submodules
        (import ./optional/home.nix)
        (import ./components/_home.nix)

        # import home.nix where located in `root/user/${username}` for specified user
        (import ../users/${username}/home.nix)
      ])
    );
  };
}
