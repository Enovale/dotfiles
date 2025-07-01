{ config, pkgs, ... }:
{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/geo" = "openstreetmap-geo-handler.desktop";
    };
  };
}
