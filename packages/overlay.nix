{
  final,
  prev,
  inputs,
  ...
}:
{
  # qt6ct-kde
  qt6Packages = prev.qt6Packages // {
    qt6ct = prev.qt6Packages.qt6ct.overrideAttrs (finalAttrs: {
      src = inputs.qt6ct-kde;

      buildInputs = with final.kdePackages; [
        kcolorscheme
        kconfig
        kiconthemes
        qqc2-desktop-style
        qtdeclarative
      ];
    });
  };

  # Remote Desktop impl fork
  xdg-desktop-portal-wlr = prev.xdg-desktop-portal-wlr.overrideAttrs (finalAttrs: {
    src = inputs.xdg-desktop-portal-wlr;
    
    patches = [
      ./remotedesktop.patch
    ];

    buildInputs =
      with final;
      [
        libxkbcommon
      ]
      ++ finalAttrs.buildInputs;
  });
}
