{
  self,
  lib,
  inputs,
  ...
}:
let
  hostsDir = ../hosts;
  nixosSystem = inputs.nixpkgs.lib.nixosSystem;
in
{
  # to generate flake configurations for hosts under ../hosts
  # using directory as hostname
  flake.nixosConfigurations = lib.genAttrs (builtins.attrNames (builtins.readDir hostsDir)) (
    hostname:
    let
      # to eval metadata for current host
      currentHost = import ../utils/evalHost.nix { inherit lib hostsDir hostname; };
      system = currentHost.architecture;
      _specialArgs = hostname: {
        inherit system inputs;
        current = currentHost;
      };
      _modules = hostname: [
        ../system
        ../home-manager

        ../overlays/nixpkgs.nix
        ../overlays/gnome.nix

        inputs.home-manager.nixosModules.home-manager

        (hostsDir + "/${hostname}/configuration.nix")
      ];
    in
    nixosSystem {
      inherit system;
      modules = _modules hostname;
      specialArgs = _specialArgs hostname;
    }
  );
}
