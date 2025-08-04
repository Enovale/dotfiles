{
  lib,
  pkg-config,
  dbus,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  inputs,
}:
rustPlatform.buildRustPackage (finalAttrs: rec {
  pname = "moonlight-canary";
  version = "0.1.11-unstable-2025-07-13";

  src = fetchFromGitHub {
    owner = "MeguminSama";
    repo = "moonlight-launcher";
    rev = "c426c3343421c8176ae740d4966f65352af77335";
    sha256 = "";
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
  ];

  cargoHash = "";

  meta = with lib; {
    description = "Moonlight Launcher (Canary Ver)";
    homepage = "https://github.com/MeguminSama/moonlight-launcher";
    license = licenses.gpl3;
  };
})
