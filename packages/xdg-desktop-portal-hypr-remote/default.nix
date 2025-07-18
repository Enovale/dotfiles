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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-desktop-portal-hypr-remote";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "gac3k";
    repo = "xdg-desktop-portal-hypr-remote";
    rev = "f463018129c5effd3b82b477d7f84fe0d0820a6b";
    hash = "sha256-hbRlPcrPWOKWZvLlnsw37/s4P+bLRq59n+R9qtVbIXc=";
  };

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
