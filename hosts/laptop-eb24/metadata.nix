{
  tags = [
    "laptop"
    "agenix"
    "btrfs"
  ];
  desktop = "gnome";
  users = [
    "erven2016"
    # "test"
  ];
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
    # waydroid.enable = true;
    # docker = {
    #   enable = true;
    #   allowUsers = [ "erven2016" ];
    # };
  };
}
