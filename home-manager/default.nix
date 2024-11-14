{ lib, current, ... }:
let
  inherit (lib) mkMerge;
in
{
  config = {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.extraSpecialArgs = {
      inherit current;
    };

    users.users = lib.genAttrs current.users (username: (import ../users/${username}));
    home-manager.users = lib.genAttrs current.users (
      username:
      (mkMerge [
        (import ../users/${username}/home.nix)
        (import ./devenv)
        ({ home.stateVersion = current.stateVersion; })
      ])
    );
  };
}
