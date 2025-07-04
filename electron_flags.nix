{
  lib,
  ...
}:
let
  chromiumFlags = ''
    --enable-zero-copy \
    --ignore-gpu-blocklist \
    --enable-native-gpu-memory-buffers \
    --enable-gpu-rasterization \
    --enable-features=VaapiVideoDecode,VaapiIgnoreDriverChecks,AcceleratedVideoDecodeLinuxGL,AcceleratedVideoEncoder,WebMachineLearningNeuralNetwork \
    --enable-raw-draw \
    --enable-unsafe-webgpu \
    --enable-blink-features=MiddleClickAutoscroll \
    --password-store="kwallet6" \
  '';
  justAttrNames =
    path: value:
    let
      attempt =
        if
          lib.isDerivation value
          &&
            # in some places we have *derivations* with jobsets as subattributes, ugh
            !(value.__recurseIntoDerivationForReleaseJobs or false)
        then
          [ path ]

        # Even wackier case: we have meta.broken==true jobs with
        # !meta.broken jobs as subattributes with license=unfree, and
        # check-meta.nix won't throw an "unfree" failure because the
        # enclosing derivation is marked broken.  Yeah.  Bonkers.
        # We should just forbid jobsets enclosed by derivations.
        else if lib.isDerivation value && !value.meta.available then
          [ ]

        else if !(lib.isAttrs value) then
          [ ]
        else if (value.__attrsFailEvaluation or false) then
          [ ]
        else
          lib.pipe value [
            (lib.attrsets.filterAttrs (
              name: value:
              true
              #builtins.hasAttr "override" value
              #builtins.elem "commandLineArgs" (builtins.attrNames value.override.__functionArgs)
            ))
            (builtins.mapAttrs (
              name: value:
              builtins.addErrorContext "while evaluating package set attribute path '${
                lib.showAttrPath (path ++ [ value ])
              }'" (justAttrNames (path ++ [ name ]) value)
            ))
            /*
            (builtins.mapAttrs (
              name: value:
              builtins.addErrorContext "while evaluating package set attribute path '${
                lib.showAttrPath (path ++ [ name ])
              }'" (justAttrNames (path ++ [ name ]) value)
            ))
            */
            builtins.attrValues
            builtins.concatLists
          ];

      seq = builtins.deepSeq attempt attempt;
      tried = builtins.tryEval seq;

      result = if tried.success then tried.value else [ ];
    in
    result;

  releaseOutpaths =
    import
      /nix/var/nix/profiles/per-user/root/channels/nixos/nixpkgs/pkgs/top-level/release-outpaths.nix
      {
        checkMeta = true;
        attrNamesOnly = true;
        path = /nix/var/nix/profiles/per-user/root/channels/nixos/nixpkgs;
      };
in
{
  nixpkgs.overlays = [
    (final: prev: {
      test2 = releaseOutpaths;
      test = justAttrNames [ ] releaseOutpaths;
    }
    /*
      builtins.mapAttrs
        (p: v: {
          name = p;
          value = v.override { commandLineArgs = chromiumFlags; };
        })
        (
          lib.attrsets.filterAttrs (
            p: v:
            let
              tried = builtins.tryEval v;
              args = builtins.attrNames v.override.__functionArgs;
              hasCmdArgs = builtins.elem "commandLineArgs" args;
              isElectron = builtins.any (z: (lib.hasPrefix "electron" z)) args;
              isPackage = lib.isDerivation v;
            in
            (tried.success && isPackage && hasCmdArgs && isElectron)
          ) pkgs
        )
    */
    )
  ];
}
