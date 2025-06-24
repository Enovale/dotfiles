{
  pkgs,
  config,
  nix-colors,
  ...
}:
{
  home.file.".local/share/color-schemes/MaterialYouDark.colors".source = ./MaterialYouDark.colors;

  #colorScheme = nix-colors.colorSchemes.dracula;

  home.pointerCursor = 
    let 
      getFrom = url: hash: name: {
          gtk.enable = true;
          x11.enable = true;
          name = name;
          size = 32;
          package = 
            pkgs.runCommand "moveUp" {} ''
              mkdir -p $out/share/icons
              ln -s ${pkgs.fetchzip {
                url = url;
                hash = hash;
              }} $out/share/icons/${name}
          '';
        };
    in
      getFrom 
        "https://github.com/ful1e5/BreezeX_Cursor/releases/download/v2.0.1/BreezeX-Black.tar.xz"
        "sha256-uRmCyFVpVN+47r9HXErxZQjheGdLPcGJTwc+mDvF9Os="
        "BreezeX-Black";
}
