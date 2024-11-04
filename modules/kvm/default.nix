{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkForce mkIf;

  cfg = config.system.kvm;
in
{

  options.system.kvm = {
    enable = mkEnableOption "KVM for system";
  };

  config = mkIf cfg.enable {

    virtualisation.libvirtd.enable = true;
    # virt-manager 需要 dconf 记住设置
    programs.dconf.enable = mkForce true;
    environment.systemPackages = with pkgs; [ virt-manager ];
  };

}
