{ lib, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      gnome = prev.gnome.overrideScope (
        gfinal: gprev: {
          mutter = gprev.mutter.overrideAttrs (oldAttrs: {
            patches = [
              (prev.fetchpatch {
                url = "https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/3751/diffs.patch";
                hash = "sha256-KOpYon8Ajzn60voOAnj6wqXxZ7nnnJ9RIPhjGBKS5uY=";
                # revert = true;
              })
            ];
          });
        }
      );
    })
  ];
}
