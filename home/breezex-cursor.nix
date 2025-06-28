{
  fetchFromGitHub,
  mkYarnPackage,
  fetchYarnDeps,
  lib,

  # build deps
  clickgen,
  python3Packages,
}:
let
  pname = "breezex-cursor";
  version = "2.0.1";
  src = fetchFromGitHub {
    owner = "ful1e5";
    repo = "BreezeX_Cursor";
    rev = "v${version}";
    hash = "sha256-P9LgQb3msq6YydK5RIk5yykUd9SL2GQbC4aH4F8LUF0=";
  };
in
mkYarnPackage rec {
  inherit pname version src;

  buildInputs = [
    clickgen
    python3Packages.attrs
  ];

  packageJSON = src + /package.json;
  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "z";
  };

  buildPhase = ''
    runHook preBuild
    export HOME=$(mktemp -d)
    # https://stackoverflow.com/a/69699772/4935114
    env NODE_OPTIONS=--openssl-legacy-provider yarn --offline install
    env NODE_OPTIONS=--openssl-legacy-provider yarn --offline generate
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    mv $out/BreezeX-* $out/share/icons

    runHook postInstall
  '';

  doDist = false;

  meta = with lib; {
    description = "BreezeX Cursor Pack";
    homepage = "https://github.com/ful1e5/BreezeX_Cursor";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      getpsyched
      yrd
    ];
    platforms = platforms.linux;
  };
}