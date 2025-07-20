{ pkgs, stdenv, fetchzip, nix-update-script, ... }:
let
  protonVersion = "8-28";
in
stdenv.mkDerivation {
  pname = "northstar-proton${protonVersion}-bin";
  version = "8-28";

  src = fetchzip {
    url = "https://github.com/R2NorthstarTools/NorthstarProton/releases/download/v${protonVersion}/NorthstarProton${protonVersion}.tar.gz";
    hash = "sha256-wCWFnirscv+oKs6v+ZNXVwM/ZnSZsjvMUt/ZKbKZnMg=";
  };

  passthru.updateScript = nix-update-script { };

  outputs = [
    "out"
    "steamcompattool"
  ];

  dontBuild = true;

  installPhase = ''
    echo "only use the steamcompattool output" > $out

    mkdir $steamcompattool
    ln -s $src/* $steamcompattool
    rm $steamcompattool/compatibilitytool.vdf
    cp $src/compatibilitytool.vdf $steamcompattool
  '';
}
