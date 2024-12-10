{
  lib,
  current,
  config,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  config = {

    # KVM dconf settings
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" =
        mkIf
          (
            (builtins.elem config.home.username current.components.kvm.allowUsers)
            && (current.components.kvm.enable)
          )
          {
            autoconnect = [ "qemu:///system" ];
            uris = [ "qemu:///system" ];
          };
    };

  };
}
