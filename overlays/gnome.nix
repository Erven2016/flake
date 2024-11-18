{ lib, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      mutter = prev.mutter.overrideAttrs (oldAttrs: {
        patches = oldAttrs.patches ++ [
          (prev.fetchpatch {
            url = "https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/3751/diffs.patch";
            hash = "sha256-m1k5zjdjzTd1vc4VeleTlmtfODS1DpcjzPiiWM5sw2M=";
            revert = true;
          })
        ];
      });
    })
  ];
}
