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
with pkgs;
stdenv.mkDerivation rec {
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

  desktopFile = makeDesktopItem {
    name = name;
    desktopName = "JDownloader";
    comment = "JDownloader download manager";
    categories = [ "Internet" ];
    icon = fetchUrl {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/jdownloader256.png?h=jdownloader2";
      hash = "";
    };
    exec = "${startScript}/bin/${name} %f";
    terminal = false;
  };

  startScript = writeShellApplication {
    name = name;
    text = ''
      #!/usr/bin/env bash

      function isRoot() {
      	if [ "$(id -u)" -eq "0" ]; then
      		return 0
      	fi
      	return 2
      }

      function changePath() {
      	if isRoot ; then
      		export JD_SCOPE="global"
      		echo "[global JDownloader scope]"
      		umask u=rwx,g=rwx,o=rx
      		cd '/var/lib/JDownloader'
      	else
      		export JD_SCOPE="user"
      		echo "[user JDownloader scope]"
      		mkdir -p "''${HOME}/.jd"
      		cd "''${HOME}/.jd"
      	fi
      }

      function downloadJDownloader() {
      	changePath
      	if [ ! -f "JDownloader.jar" ]; then
          #ln -fs ${src} JDownloader.jar
          cp ${src} JDownloader.jar
      	fi
        chmod 777 JDownloader.jar
      }

      changePath
      downloadJDownloader

      exec ${jre}/bin/java -jar JDownloader.jar "$@"
    '';
  };

  installPhase = ''
    mkdir -p $out/share/java/jdownloader2
    install ${src} $out/share/java/jdownloader2/JDownloader.jar
    mkdir -p $out/bin

    install ${startScript}/bin/${name} $out/bin/jdownloader2

    chmod 777 $out/share/java/jdownloader2/JDownloader.jar
    chmod +x $out/bin/jdownloader2

    mkdir -p $out/share/applications
    install ${desktopFile}/share/applications/${name}.desktop $out/share/applications/${name}.desktop
  '';

}
