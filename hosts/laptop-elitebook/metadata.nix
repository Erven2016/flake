{
  tags = [
    "flatpak"
    "kvm"
  ];
  preferDesktop = "gnome";
  users = [ "erven2016" ];
  i18n = {
    supportedLocales = [ "zh_CN.UTF-8/UTF-8" ];
  };
  efiSysMountPoint = "/boot";
}
