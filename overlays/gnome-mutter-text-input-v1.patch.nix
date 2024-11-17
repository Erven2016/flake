{
  nixpkgs.overlays = [
    (self: super: {
      gnome = super.gnome.overrideScope' (
        pself: psuper: {
          mutter = psuper.mutter.overrideAttrs (oldAttrs: {
            patches = (oldAttrs.patches or [ ]) ++ [

              # grab.patch
              (super.fetchpatch {
                url = "https://gitlab.gnome.org/GNOME/mutter/-/commit/a99e139a68bd4e5350033163dfd85b6ce6da92a2.patch";
                hash = "sha256-L8GGEFHE566yvpAAVXA8bn2hvDfFAO8S/MqPM3Oki90=";
                revert = true;
              })

              # text-input-v1.patch
              (super.fetchpatch {
                url = "https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/3751/diffs.patch";
                hash = "sha256-L8GGEFHE566yvpAAVXA8bn2hvDfFAO8S/MqPM3Oki90=";
                revert = true;
              })
            ];
          });
        }
      );
    })
  ];
}
