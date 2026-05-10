{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # SecureBoot
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";

      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      ...
    }@inputs:
    let
    in
    {
      nixosConfigurations."bshell" = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./machines/tablet-bshell

          inputs.lanzaboote.nixosModules.lanzaboote

          # To use nixpkg-unstable
          {
            nixpkgs.overlays = [
              (final: _prev: {
                unstable = import nixpkgs-unstable {
                  inherit (_prev) hostPlatform config;
                };
              })
            ];
          }

        ];
      };
    };
}
