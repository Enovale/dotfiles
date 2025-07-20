{ callPackage, inputs, ... }:
{
  avidemux-qt6 = callPackage ./avidemux { inherit inputs; };
  jdownloader2 = callPackage ./jdownloader2 { inherit inputs; };
  media-fetcher = callPackage ./media-fetcher { inherit inputs; };
  xdg-desktop-portal-hypr-remote = callPackage ./xdg-desktop-portal-hypr-remote { inherit inputs; };
}
