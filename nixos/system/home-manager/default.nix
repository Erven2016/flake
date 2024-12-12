{ current, config, ... }:
let
  users = config.users.users;
in
{
  config = {

    # set Home-manager plugin options
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.extraSpecialArgs = { inherit current users; };

  };
}
