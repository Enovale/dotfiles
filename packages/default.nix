{ callPackage, ... }:
{
  avidemux-qt6 = callPackage ./avidemux { };
  jdownloader2 = callPackage ./jdownloader2 { };
  media-fetcher = callPackage ./media-fetcher { };
  xdg-desktop-portal-hypr-remote = callPackage ./xdg-desktop-portal-hypr-remote { };
}
