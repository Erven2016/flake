{ lib, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      mutter = prev.mutter.overrideAttrs (oldAttrs: {
        patches = oldAttrs.patches ++ [
          ../patches/mutter-text-input-v1.patch
        ];
      });
    })
  ];
}
