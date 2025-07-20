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
  version = "media-fetcher-releases-unstable-2025-07-10";

  src = fetchFromGitHub {
    owner = "NotNite";
    repo = "my-moonlight-extensions";
    rev = "033fbf68560b6000004b591d9570075bdc884a44";
    sha256 = "sha256-EMCQFJELfU92bPjqytHDaj1kA+DLmBjLgTZ8psPkpcg=";
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
