{
  config,
  pkgs,
  current,
  inputs,
  ...
}:
{
  nixpkgs.overlays = [
    (final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        inherit (final) system;
        config.allowUnfree = current.allowUnfreePackages;
        config.nvidia.acceptLicense = true;
      };
    })
  ];
}
