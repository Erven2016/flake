{
  imports = [
    ./base
    ./kernel
    ./bootloader
    ./overlays
    ./flatpak
    ./sound
    ./fonts
    ./kvm
    ./desktop
    ./devel # Development toolkits

    # test purpose
    # todo: improve this
    ./power-management/suspend-then-hibernate.nix
  ];
}
