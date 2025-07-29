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
  libsForQt5 = prev.libsForQt5 // {
    qt5ct = prev.libsForQt5.qt5ct.overrideAttrs (finalAttrs: {
      src = inputs.qt5ct-kde;

      patches = [
        ./qt5ct-shenanigans.patch
      ];

      postPatch = ''
        substituteInPlace src/qt5ct-qtplugin/CMakeLists.txt src/qt5ct-style/CMakeLists.txt \
          --replace-fail "\''${PLUGINDIR}" "$out/${final.libsForQt5.qtbase.qtPluginPrefix}"
      '';

      nativeBuildInputs = with final.libsForQt5; [
        final.cmake
        qttools
        wrapQtAppsHook
        kconfig
        kiconthemes
        qqc2-desktop-style
        qtquickcontrols2
        qtdeclarative
      ];
    });
  };
  
  # Currently doesn't work
  /*
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
  */
}
