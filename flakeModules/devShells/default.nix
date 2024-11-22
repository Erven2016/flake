{ pkgs, ... }:
{
  devShells.default = pkgs.mkShell {
    shellHook = ''
      echo "Hello World!"
    '';
  };
}
