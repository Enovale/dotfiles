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
  pname = "media-fetcher";
  version = "media-fetcher-releases-unstable-2025-08-10";

  src = fetchFromGitHub {
    owner = "NotNite";
    repo = "my-moonlight-extensions";
    rev = "d35b5d7f10554c42d467a008132b5618c77acee3";
    sha256 = "sha256-HBakcjdVLE/GnomTSUjfv2FeOzYKp2P7Y7rYjOI2wpA=";
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

  sourceRoot = "${src.name}/src/mediaControls/media-fetcher";

  cargoHash = "sha256-Hrn47kGCqgoAMgrEgpRj4a38+7vhVZFrLUR2vXU7Sb4=";

  meta = with lib; {
    description = "Media fetcher for moonlight plugin";
    homepage = "https://github.com/NotNite/my-moonlight-extensions";
    license = licenses.unlicense;
  };
})
