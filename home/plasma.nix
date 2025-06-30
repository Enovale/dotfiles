{ osConfig, pkgs, lib, ... }:
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
  ];

  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = lib.mkForce "plasma-integration";
  };

  programs.plasma = {
    enable = true;
    workspace = {
      clickItemTo = "select";
      lookAndFeel = "org.kde.breezedark.desktop";
      colorScheme = "MaterialYouDark";
      wallpaper = "${osConfig.global.wallpaper}";
      cursor.theme = osConfig.global.cursorName;
      cursor.size = osConfig.global.cursorSize;
    };
    hotkeys.commands."anyrun" = {
      name = "Launch Anyrun";
      key = "Alt+Space";
      command = "anyrun";
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
}
