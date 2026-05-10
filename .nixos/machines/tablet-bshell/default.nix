{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix

    # import modules
    ../_modules/flatpak.nix
    ../_modules/gnome.nix
  ];
  config = {
    networking.hostName = "bshell";

    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Configure network connections interactively with nmcli or nmtui.
    networking.networkmanager.enable = true;

    # enable for screen ratate.
    hardware.sensor.iio.enable = true;

    # Set your time zone.
    time.timeZone = "Asia/Taipei";

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";
    # console = {
    #   font = "Lat2-Terminus16";
    #   keyMap = "us";
    #   useXkbConfig = true; # use xkb.options in tty.
    # };

    # Enable CUPS to print documents.
    # services.printing.enable = true;

    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    # Define a user account. Don't forget to set a password with ‘passwd’.
    # users.users.alice = {
    #   isNormalUser = true;
    #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    #   packages = with pkgs; [
    #     tree
    #   ];
    # };

    # List packages installed in system profile.
    # You can use https://search.nixos.org/ to find more packages (and options).
    environment.systemPackages = with pkgs; [
      wget
      helix
      # nil
      nixd
      fastfetch
      zed-editor
      nixfmt
      btop
      sbctl # for generating secure boot custom key

      git

      unstable.throne

    ];

    services.udev.packages = with pkgs; [
      gnome-settings-daemon
    ];

    # Font
    fonts.fontconfig.useEmbeddedBitmaps = true;
    fonts.fontDir.enable = true;
    fonts.packages = with pkgs; [
      dejavu_fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      roboto
    ];

    programs.proxychains = {
      enable = true;
      proxies = {
        a = {
          type = "socks5";
          host = "127.0.0.1";
          port = 2080;
          enable = true;
        };
      };
    };

    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver # For Broadwell (2014) or newer processors. LIBVA_DRIVER_NAME=iHD
        intel-vaapi-driver # For older processors. LIBVA_DRIVER_NAME=i965
      ];
    };
    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
    }; # Optionally, set the environment variable
    hardware.graphics.extraPackages32 = with pkgs.pkgsi686Linux; [ intel-vaapi-driver ];

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    # List services that you want to enable:

    # Enable the OpenSSH daemon.
    # services.openssh.enable = true;

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    networking.firewall.enable = false; # To use GS connect

    # This option defines the first version of NixOS you have installed on this particular machine,
    # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
    #
    # Most users should NEVER change this value after the initial install, for any reason,
    # even if you've upgraded your system to a new NixOS release.
    #
    # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
    # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
    # to actually do that.
    #
    # This value being lower than the current NixOS release does NOT mean your system is
    # out of date, out of support, or vulnerable.
    #
    # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
    # and migrated your data accordingly.
    #
    # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
    system.stateVersion = "25.11"; # Did you read the comment?

  };
}
