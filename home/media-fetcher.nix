{
  lib,
  pkg-config,
  dbus,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: rec {
  pname = "media-fetcher";
  version = "14.1.1";

  src = fetchFromGitHub {
    owner = "NotNite";
    repo = "my-moonlight-extensions";
    rev = "78f1a5d55c65f87426b112129e4b9125d6670b7c";
    sha256 = "sha256-g+mGOcERHX3ZaIBS+0d3gRBxKyRxL9GyzGBP+2sAUIo=";
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
    description = "Fast line-oriented regex search tool, similar to ag and ack";
    homepage = "https://github.com/BurntSushi/ripgrep";
    license = licenses.unlicense;
    maintainers = [ maintainers.enova ];
  };
})
