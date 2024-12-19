# to change the cache directory of nix-daemon
{
  config = {
    systemd.services.nix-daemon = {
      environment = {
        TMPDIR = "/var/cache/nix";
      };
      serviceConfig = {
        CacheDirectory = "nix";
      };
    };

    environment.variables.NIX_REMOTE = "daemon";
  };
}
