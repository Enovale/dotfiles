{ pkgs, stdenv, fetchzip, ... }:
let
  bosonVersion = "0.3.0";
in
stdenv.mkDerivation {
  pname = "boson-${bosonVersion}-bin";
  version = "1.0";

  src = fetchzip {
    url = "https://github.com/FyraLabs/boson/releases/download/v${bosonVersion}/boson-${bosonVersion}-x86_64-musl.tar.zst";
    hash = "sha256-1muEpuwVm0tRJirWTc2zIo2mE0lrhXUf74XLhUmkdnk=";
    nativeBuildInputs = [ pkgs.zstd ];
  };

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
