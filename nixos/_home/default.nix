{ current, ... }:
{
  config = {

    # set Home-manager plugin options
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.extraSpecialArgs = { inherit current; };

  };
}
