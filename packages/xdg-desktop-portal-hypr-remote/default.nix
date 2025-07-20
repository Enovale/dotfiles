{
  lib,
  stdenv,
  pkg-config,
  fetchFromGitHub,
  cmake,
  xdg-desktop-portal,
  wayland,
  wayland-protocols,
  wayland-scanner,
  libei,
  sdbus-cpp,
  systemd,
  inputs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-desktop-portal-hypr-remote";
  version = "1.0.0";

  src = inputs.xdg-desktop-portal-hypr-remote;

  cmakeFlags = [
    "-DDEVELOPMENT_MODE=OFF"
  ];

  nativeBuildInputs = [
    pkg-config
    wayland-protocols
    wayland-scanner
    cmake
    sdbus-cpp
  ];

  buildInputs = [
    xdg-desktop-portal
    wayland
    libei
    systemd
  ];

  meta = {
    description = "Filechooser portal backend for any desktop environment";
    homepage = "https://github.com/Decodetalkers/xdg-desktop-portal-shana";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      samuelefacenda
      Rishik-Y
      Gliczy
    ];
  };
})
