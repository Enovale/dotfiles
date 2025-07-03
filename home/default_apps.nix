{ config, pkgs, ... }:
{
  xdg.mimeApps = {
    # TODO This currently overrides existing associations which SUCKS
    #enable = true;
    defaultApplications = {
      "x-scheme-handler/geo" = "openstreetmap-geo-handler.desktop";
    };
  };
}
