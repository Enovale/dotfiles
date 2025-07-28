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
  version = "media-fetcher-releases-unstable-2025-07-27";

  src = fetchFromGitHub {
    owner = "NotNite";
    repo = "my-moonlight-extensions";
    rev = "a1d0e9871f8c2c289f0a9b33ac365cbaf1fc92bc";
    sha256 = "sha256-N8+AiqouA1bcTs7hW/TMSNAsujOUdxodLgrz41wYfHA=";
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
