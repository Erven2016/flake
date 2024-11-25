{
  description = "";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };
  outputs =
    { inputs, nixpkgs, ... }:
    let
      system = "x86_64-linux";
    in
    {
      devShells.${system}.default =
        { pkgs, ... }:
        pkgs.mkShell {
          shellHook = ''
            echo "Hello World!"
          '';
        };
    };
}
