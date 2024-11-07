{
  description = "My personal NixOS configuration";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-24.05";
    };
    nixpkgs-unstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur-erven2016 = {
      url = "github:Erven2016/nur/master";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    distro-grub-themes = {
      url = "github:AdisonCavani/distro-grub-themes/master";
    };
    dynamic-gnome-wallpapers.url = "github:Erven2016/dynamic-gnome-wallpapers.nur/master";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      nur-erven2016,
      nixos-hardware,
      home-manager,
      distro-grub-themes,
      dynamic-gnome-wallpapers,
      ...
    }:
    let
      genericModules = [

        # home-manager
        home-manager.nixosModules.home-manager
        ./modules/home-manager-options.nix

        (
          { config, pkgs, ... }:
          {
            nixpkgs.overlays = [
              overlay-nixpkgs-unstable
              overlay-nur-erven2016
              overlay-nur-dynamic-gnome-wallpapers
            ];
          }
        )
      ];

      # overlays
      overlay-nixpkgs-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit (final) system;
          config.allowUnfree = true;
          config.nvidia.acceptLicense = true;
        };
      };
      overlay-nur-erven2016 = final: prev: {
        nur-erven2016 = import nur-erven2016 {
          # inherit (final) system;
          # config.allowUnfree = true;
        };
      };
      overlay-nur-dynamic-gnome-wallpapers = final: prev: {
        dynamic-gnome-wallpapers = import dynamic-gnome-wallpapers { };
      };
    in
    {
      # HP HP EliteBook 845 14 inch G11 Notebook PC
      nixosConfigurations."EliteBook845G11" = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inherit system inputs;
        };
        modules = genericModules ++ [
          ./configuration.nix
          ./hosts/EliteBook845G11.nix

          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-cpu-amd-pstate
          # nixos-hardware.nixosModules.common-cpu-amd-zenpower
          nixos-hardware.nixosModules.common-gpu-amd
          nixos-hardware.nixosModules.common-hidpi

          # Home Manager
          ./users/erven2016.nix

        ];
      };
    };
}
