{
  # self,
  lib,
  inputs,
  ...
}:
let
  inherit (import ../utils) evalHost;

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
      currentHost = evalHost { inherit lib hostsDir hostname; };
      system = currentHost.architecture;

      _specialArgs = hostname: {
        inherit system inputs;
        current = currentHost;
      };

      _modules = hostname: [
        ../nixos
        ../secrets
        ../overlays

        inputs.home-manager.nixosModules.home-manager
        inputs.agenix.nixosModules.default

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
