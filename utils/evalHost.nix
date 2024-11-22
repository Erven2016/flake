{
  lib,
  hostsDir,
  hostname,
  ...
}@args:
(lib.evalModules {
  modules = [
    ./options/metadata.nix
    (args.hostsDir + "/${args.hostname}/metadata.nix")
  ];
  specialArgs = {
    hostname = args.hostname;
  };
}).config
