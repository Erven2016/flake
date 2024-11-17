{
  current,
  inputs,
  ...
}:
{
  nixpkgs.overlays = [
    # nixpkgs-unstable
    (final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        inherit (final) system;
        config.allowUnfree = current.allowUnfreePackages;
        config.nvidia.acceptLicense = true;
      };
    })
    # nur-erven2016
    (final: prev: {
      erven2016 = import inputs.nur-erven2016 {
        # inherit (final) system;
        # config.allowUnfree = current.allowUnfreePackages;
        # config.nvidia.acceptLicense = true;
      };
    })
  ];
}
