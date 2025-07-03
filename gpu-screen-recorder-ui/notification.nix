{
  config,
  pkgs ? import <nixpkgs> { },
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  addDriverRunpath,
  makeWrapper,
  meson,
  ninja,
  libdrm,
  gpu-screen-recorder,
  libglvnd,
  libX11,
  libXrandr,
  libXext,
  wayland,
  wayland-scanner,
  wrapperDir ? "/run/wrappers/bin",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gpu-screen-recorder-notification";
  version = "1.0.7";

  src = fetchurl {
    url = "https://dec05eba.com/snapshot/gpu-screen-recorder-notification.git.${finalAttrs.version}.tar.gz";
    hash = "sha256-zeL15/rSPasZ98FWkG4BMlBxszvZJS8MGr6557OGeE4=";
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
    libXext
    libdrm
    libX11
    libXrandr
    wayland
  ];

  preFixup =
    let
      gpu-screen-recorder-wrapped = gpu-screen-recorder.override {
        inherit wrapperDir;
      };
    in
    ''
      wrapProgram $out/bin/gsr-notify \
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
    description = "Notification overlay for gpu-screen-recorder-ui.";
    homepage = "https://git.dec05eba.com/gpu-screen-recorder-notification/about/";
    license = lib.licenses.gpl3Only;
    mainProgram = "gpu-screen-recorder-notification";
    maintainers = with lib.maintainers; [ enova ];
    platforms = [ "x86_64-linux" ];
  };
})
