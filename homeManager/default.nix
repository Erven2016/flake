{
  lib,
  current,
  pkgs,
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
      username:
      mkMerge [
        (import ../users/${username} { inherit lib pkgs; })
        ({
          extraGroups = mkMerge [
            (mkIf (builtins.elem username current.components.kvm.allowUsers) [ "libvirtd" ])
          ];
        })
      ]
    );

    home-manager.users = lib.genAttrs current.users (
      username:
      (mkMerge [

        {
          # Set stateVersion
          home.stateVersion = current.stateVersion;
        }

        # to import home-mananger submodules
        (import ./devenv)
        (import ./helix)
        (import ./zsh)
        (import ./git)
        (import ./optional)

        # to import home.nix where located in `root/user/${username}` for specified user
        (import ../users/${username}/home.nix)

        # KVM dconf settings
        (mkIf
          ((builtins.elem username current.components.kvm.allowUsers) && (current.components.kvm.enable))
          {
            dconf.settings = {
              "org/virt-manager/virt-manager/connections" = {
                autoconnect = [ "qemu:///system" ];
                uris = [ "qemu:///system" ];
              };
            };
          }
        )
      ])
    );
  };
}
