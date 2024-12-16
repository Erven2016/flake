{
  lib,
  current,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkMerge mkIf mkDefault;

  superConfig = config;
in
{
  imports = [
    ./system

    ./desktop/system.nix
    ./components/system.nix
    ./optional/system.nix
  ];

  config = {
    # instantiate users
    users.users = lib.genAttrs current.users (
      username:
      { config, ... }:
      mkMerge [
        (import ../users/${username} { inherit lib pkgs superConfig; })
        {
          isNormalUser = true;
          extraGroups = mkMerge [
            (mkIf (builtins.elem username current.components.kvm.allowUsers) [ "libvirtd" ])
            (mkIf (builtins.elem username current.components.docker.allowUsers) [ "docker" ])
          ];
          shell = mkDefault pkgs.bash; # set default shell
          ignoreShellProgramCheck = true;
          packages = [
            config.shell # make sure that default shell is installed
          ];
        }
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
        (import ./components/home.nix)
        (import ./desktop/home.nix)

        # import home.nix where located in `root/user/${username}` for specified user
        (import ../users/${username}/home.nix)
      ])
    );
  };
}
