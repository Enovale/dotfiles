{ pkgs, ... }:
{
  home.packages = with pkgs.kdePackages; [
    polkit-kde-agent-1
    kate
    kcolorscheme
    kcolorchooser
    kolourpaint
    kfind
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

  programs.plasma = {
    enable = true;
    workspace = {
      clickItemTo = "select";
      lookAndFeel = "org.kde.breezedark.desktop";
      cursor.theme = "BreezeX-Dark";
    };
    configFile = {
      "kwinrc"."Plugins"."shakecursorEnabled" = false;
    };
  };
}
