{
  pkgs,
  config,
  nix-colors,
  ...
}:
{
  home.file.".local/share/color-schemes/MaterialYouDark.colors".source = ./MaterialYouDark.colors;

  qt = {
    enable = true;
    platformTheme.name = "qtct";
  };

  gtk = {
    enable = true;
    theme = {
      name = "breeze-dark";
    };

    iconTheme = {
      name = "breeze-dark";
    };

    font = {
      name = "Noto Sans";
      package = pkgs.noto-fonts;
      size = 12;
    };

    cursorTheme = {
      name = "BreezeX-Black";
      size = 32;
    };

    gtk2.extraConfig = ''
      gtk-enable-animations=1
      gtk-primary-button-warps-slider=1
      gtk-toolbar-style=3
      gtk-menu-images=1
      gtk-button-images=1
      gtk-cursor-blink-time=1000
      gtk-cursor-blink=1
      gtk-sound-theme-name="ocean"
    '';
  };

  home.sessionVariables = {
    #QT_QPA_PLATFORMTHEME = "qt5ct";
  };

  #colorScheme = nix-colors.colorSchemes.dracula;

  home.pointerCursor =
    let
      getFrom = url: hash: name: {
        gtk.enable = true;
        x11.enable = true;
        hyprcursor.enable = true;
        name = name;
        size = 32;
        package = pkgs.runCommand "moveUp" { } ''
          mkdir -p $out/share/icons
          ln -s ${
            pkgs.fetchzip {
              url = url;
              hash = hash;
            }
          } $out/share/icons/${name}
        '';
      };
    in
    getFrom "https://github.com/ful1e5/BreezeX_Cursor/releases/download/v2.0.1/BreezeX-Black.tar.xz"
      "sha256-uRmCyFVpVN+47r9HXErxZQjheGdLPcGJTwc+mDvF9Os="
      "BreezeX-Black";
}
