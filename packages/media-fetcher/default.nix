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
  version = "media-fetcher-releases-unstable-2025-07-25";

  src = fetchFromGitHub {
    owner = "NotNite";
    repo = "my-moonlight-extensions";
    rev = "314602dddad3d4b402c2774360a8cc8c61c2f546";
    sha256 = "sha256-VII9CJQpZo1ih/xZcdy2k1B+I5lqgnwRM3EwtG0utas=";
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
