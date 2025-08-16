{
  lib,
  pkgs,
  pkg-config,
  dbus,
  fetchFromGitHub,
  rustPlatform,
  makeWrapper,
  nix-update-script,
  inputs,
  rust-bin,
  makeRustPlatform,
  naersk,
}:
let
  rustPlatform = makeRustPlatform {
    cargo = rust-bin.nightly."2025-03-01".default;
    rustc = rust-bin.nightly."2025-03-01".default;
  };
in
rustPlatform.buildRustPackage (finalAttrs: rec {
  pname = "moonlight-launcher";
  version = "0.1.11-unstable-2025-07-13";

  src = fetchFromGitHub {
    owner = "MeguminSama";
    repo = "moonlight-launcher";
    rev = "c426c3343421c8176ae740d4966f65352af77335";
    sha256 = "sha256-wRl003T+MPP6/nkSJnS5kOEwMznzKVy8RGfMwnwgfaY=";
  };

  prePatch = ''
    substituteInPlace ./Cargo.toml \
      --replace 'electron-hook = "0.2.1"' 'electron-hook = { path = "${./electron-hook}" }'
  '';

  cargoHash = "sha256-Yl467NU1H1GeuUUylMudLrrdg74uPs1CrMwp0S4VFZ0=";

  nativeBuildInputs = [ makeWrapper ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };  

  buildType = "release";
  # TODO

  meta = with lib; {
    description = "Moonlight Launcher (Canary Ver)";
    homepage = "https://github.com/MeguminSama/moonlight-launcher";
    license = licenses.gpl3;
  };
})
