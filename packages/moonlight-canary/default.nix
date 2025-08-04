{
  lib,
  pkgs,
  pkg-config,
  dbus,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  inputs,
  rust-bin,
  makeRustPlatform,
  naersk
}:
let
  rustPlatform = makeRustPlatform {
    cargo = rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
    rustc = rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
  };

in
/*
naersk.buildPackage {
  src = fetchFromGitHub {
    owner = "MeguminSama";
    repo = "moonlight-launcher";
    rev = "c426c3343421c8176ae740d4966f65352af77335";
    sha256 = "sha256-wRl003T+MPP6/nkSJnS5kOEwMznzKVy8RGfMwnwgfaY=";
  };
  cargoBuildOptions = orig: orig ++ [
    "--workspace"
  ];
}
*/
  rustPlatform.buildRustPackage (finalAttrs: rec {
    pname = "moonlight-canary";
    version = "0.1.11-unstable-2025-07-13";

    src = fetchFromGitHub {
      owner = "MeguminSama";
      repo = "moonlight-launcher";
      rev = "c426c3343421c8176ae740d4966f65352af77335";
      sha256 = "sha256-wRl003T+MPP6/nkSJnS5kOEwMznzKVy8RGfMwnwgfaY=";
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

    buildType = "release";
    buildFlags = [
      "--all"
    ];

    cargoHash = "sha256-Yl467NU1H1GeuUUylMudLrrdg74uPs1CrMwp0S4VFZ0=";

    meta = with lib; {
      description = "Moonlight Launcher (Canary Ver)";
      homepage = "https://github.com/MeguminSama/moonlight-launcher";
      license = licenses.gpl3;
    };
  })