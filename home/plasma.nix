{
  osConfig,
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs.kdePackages; [
    knewstuff
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
    kdenlive
    kcalc
    filelight
    pkgs.kile
    pkgs.okteta
    pkgs.krita
    xdg-desktop-portal-kde
    xwaylandvideobridge
  ];

  # Programs need to be run with plasma-integration to not have broken disabled colors
  # But this doesn't work when not actually running plasma. Only fix is qt6ct-kde.
  home.sessionVariables = {
    #QT_QPA_PLATFORMTHEME = lib.mkForce "plasma-integration";
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
    fonts = rec {
      general = {
        family = osConfig.global.fontFamily;
        pointSize = osConfig.global.fontSize;
      };
      fixedWidth = {
        family = osConfig.global.fixedFontFamily;
        pointSize = osConfig.global.fontSize;
      };
      small = {
        family = general.family;
        pointSize = osConfig.global.fontSize - 2;
      };
      toolbar = general;
      windowTitle = general;
      menu = general;
    };
    hotkeys.commands."anyrun" = {
      name = "Launch Anyrun";
      key = "Alt+Space";
      command = "anyrun";
    };
    shortcuts = {
      "services/kitty.desktop"."_launch" = "Ctrl+Alt+T";
    };
    kwin = {
      effects = {
        shakeCursor.enable = false;
      };
    };
    configFile = {
      # TODO Figure out if this can become global for all mice
      kcminputrc."Libinput/9639/64007/Compx 2.4G Wireless Receiver".PointerAcceleration = 0.400;
      kcminputrc."Libinput/9639/64007/Compx 2.4G Wireless Receiver".PointerAccelerationProfile = 1;
      kwinrc.Wayland."InputMethod[$e]" =
        "/run/current-system/sw/share/applications/com.github.maliit.keyboard.desktop";
      kdeglobals.KDE.SingleClick = false;
      kwinrc.EdgeBarrier.CornerBarrier = false;
      kwinrc.EdgeBarrier.EdgeBarrier = 0;
      kdeglobals.General.AccentColor = "141,0,79";
      #"kdeglobals"."KDE"."widgetStyle" = "qt6ct-style";
      kdeglobals.General.TerminalApplication = "kitty";
      kdeglobals.UiSettings.ColorScheme = "*";
      dolphinrc.UiSettings.ColorScheme = "*";
      katerc.General."Show Url Nav Bar" = true;
    };
  };
}
