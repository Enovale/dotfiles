{
  pkgs ? import <nixpkgs> { },
  fetchurl ? pkgs.fetchurl,
  makeWrapper,
  jre,
}:
let
  desktopFile = fetchurl {
    url = "https://aur.archlinux.org/cgit/aur.git/plain/jdownloader.desktop?h=jdownloader2";
  };
in
pkgs.stdenv.mkDerivation {
  # name of our derivation
  name = "jdownloader2";
  dontUnpack = true;

  # sources that will be used for our derivation.
  src = fetchurl {
    url = "https://installer.jdownloader.org/JDownloader.jar";
    hash = "sha256-DBiUEh1fXFF5/Qf3/+mQ34iVK9p7QOG1WefxSyC99t4=";
  };

  meta.mainProgram = "jdownloader2";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/share/java
    install $src $out/share/java/JDownloader.jar
    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/jdownloader2 \
      --add-flags "-cp $out/share/java/JDownloader.jar org.jdownloader.update.launcher.JDLauncher"
  '';

}
