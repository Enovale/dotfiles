{ config, pkgs, ... }:
{
  home.packages = with pkgs.kdePackages; [
    polkit-kde-agent-1
    kimageformats # avif, xcf, jxl
    kdegraphics-thumbnailers # PS, PDF, RAW, mobi, blender
    ffmpegthumbs # video thumbnails
    qtimageformats # for webp thumbnails
    kate
    kcolorscheme
    kcolorchooser
    kolourpaint
    kfind
    ksystemlog
    isoimagewriter
    partitionmanager
    kdenlive
    kcalc
    filelight
    pkgs.kile
    pkgs.okteta
    pkgs.krita
    xdg-desktop-portal-kde
    xwaylandvideobridge
    #(pkgs.callPackage ./breezex-cursor.nix {}) # TODO
  ];

  programs.plasma = {
    enable = true;
    workspace = {
      clickItemTo = "select";
      lookAndFeel = "org.kde.breezedark.desktop";
      colorScheme = "MaterialYouDark";
      cursor.theme = "BreezeX-Black";
    };
    kwin = {
      effects = {
        shakeCursor.enable = false;
      };
    };
    configFile = {
      kdeglobals.KDE.SingleClick = false;
      kdeglobals.General.AccentColor = "141,0,79";
      #"kdeglobals"."KDE"."widgetStyle" = "qt6ct-style";
      kdeglobals.General.TerminalApplication = "kitty";
      kdeglobals.UiSettings.ColorScheme = "*";
      dolphinrc.UiSettings.ColorScheme = "*";
    };
  };

  # TODO This doesn't work
  xdg.configFile."qt5ct/colors/MaterialYouDark.colors" = {
    enable = true;
    source = ./MaterialYouDark.colors;
  };

  xdg.configFile."qt6ct/colors/MaterialYouDark.colors" = {
    enable = true;
    source = ./MaterialYouDark.colors;
  };

  gtk = {
    enable = true;

    cursorTheme = {
      name = "BreezeX-Black";
      size = 32;
    };
  };
}
