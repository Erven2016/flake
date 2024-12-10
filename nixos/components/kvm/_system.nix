{ current, lib, ... }:
let
  inherit (lib) mkIf;

  cfg = current.components.kvm;
in
{
  config = mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;
  };
}
