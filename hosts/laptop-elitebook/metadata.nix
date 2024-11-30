{
  tags = [ "laptop" ];
  desktop = "gnome";
  users = [ "erven2016" ];
  i18n = {
    supportedLocales = [ "zh_CN.UTF-8/UTF-8" ];
  };
  efiSysMountPoint = "/boot";

  components = {
    flatpak.enable = true;
    kvm = {
      enable = true;
      allowUsers = [ "erven2016" ];
    };
    devenv.enable = true;
  };

  nix.allowUsers = [ "erven2016" ];
}
