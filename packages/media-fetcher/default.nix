{
  lib,
  pkg-config,
  dbus,
  fetchFromGitHub,
  rustPlatform,
  inputs,
}:
rustPlatform.buildRustPackage (finalAttrs: rec {
  pname = "media-fetcher";
  version = "14.1.1";

  src = inputs.media-fetcher;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
  ];

  sourceRoot = "./";
  preUnpack = ''
    cp -r ${src}/src/mediaControls/media-fetcher/* ./
  '';

  cargoHash = "sha256-Hrn47kGCqgoAMgrEgpRj4a38+7vhVZFrLUR2vXU7Sb4=";

  meta = with lib; {
    description = "Media fetcher for moonlight plugin";
    homepage = "https://github.com/NotNite/my-moonlight-extensions";
    license = licenses.unlicense;
    maintainers = [ maintainers.enova ];
  };
})
