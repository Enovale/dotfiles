{ pkgs, ... }:
{
  programs.plasma = {
    enable = true;
    workspace = {
      clickItemTo = "select";
      lookAndFeel = "org.kde.breezedark.desktop";
      cursor.theme = "BreezeX-Dark";
    };
  };
}
