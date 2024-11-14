{
  lib,
  current,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkMerge mkIf;
in
{
  config = {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.extraSpecialArgs = {
      inherit current;
    };

    users.users = lib.genAttrs current.users (
      username: mkMerge [ (import ../users/${username} { inherit lib pkgs; }) ]

    );

    home-manager.users = lib.genAttrs current.users (
      username:
      (mkMerge [

        ({
          # Set stateVersion
          home.stateVersion = current.stateVersion;
        })

        # to import home-mananger submodules
        (import ./devenv)
        (import ./helix)
        (import ./zsh)

        # to import home.nix where located in `root/user/${username}` for specified user
        (import ../users/${username}/home.nix)
      ])
    );
  };
}
