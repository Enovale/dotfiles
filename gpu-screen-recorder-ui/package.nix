{
  config,
  pkgs ? import <nixpkgs> { },
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  addDriverRunpath,
  desktop-file-utils,
  makeWrapper,
  meson,
  ninja,
  libpulseaudio,
  libdrm,
  gpu-screen-recorder,
  libglvnd,
  libX11,
  libXrandr,
  libXcomposite,
  libXcursor,
  libXext,
  libXi,
  libcap,
  wayland,
  wayland-scanner,
  wrapperDir ? "/run/wrappers/bin",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gpu-screen-recorder-ui";
  version = "1.6.7";

  src = fetchurl {
    url = "https://dec05eba.com/snapshot/gpu-screen-recorder-ui.git.${finalAttrs.version}.tar.gz";
    hash = "sha256-H1hkcpiGyy4KS6WLJPaQ5I0ffzHGC/jr7yYbFyrLIeg=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    meson
    ninja
    wayland-scanner
  ];

  buildInputs = [
    libpulseaudio
    libdrm
    libX11
    libXrandr
    libXcomposite
    libXcursor
    libXext
    libXi
    libcap
    wayland
  ];

  preFixup =
    let
      gpu-screen-recorder-wrapped = gpu-screen-recorder.override {
        inherit wrapperDir;
      };
    in
    ''
      wrapProgram $out/bin/gsr-ui \
      --prefix PATH : ${wrapperDir} \
      --suffix PATH : ${lib.makeBinPath [ gpu-screen-recorder-wrapped ]} \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libglvnd
          addDriverRunpath.driverLink
        ]
      }
    '';

  meta = {
    #changelog = "https://git.dec05eba.com/gpu-screen-recorder-ui/tree/com.dec05eba.gpu_screen_recorder.appdata.xml#n82";
    description = "Shadowplay-like frontend for gpu-screen-recorder.";
    homepage = "https://git.dec05eba.com/gpu-screen-recorder-ui/about/";
    license = lib.licenses.gpl3Only;
    mainProgram = "gpu-screen-recorder-ui";
    maintainers = with lib.maintainers; [ enova ];
    platforms = [ "x86_64-linux" ];
  };
})
