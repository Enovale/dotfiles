{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
{
  options = {
    global = mkOption {
      readOnly = true;
      type = types.submodule {
        options = {
          username = mkOption {
            type = types.str;
            readOnly = true;
          };
          cursorName = mkOption {
            type = types.str;
            readOnly = true;
          };
          cursorSize = mkOption {
            type = types.int;
            readOnly = true;
          };
          wallpaper = mkOption {
            type = types.package;
            readOnly = true;
          };
        };
      };
    };
  };

  config = {
    global = {
      username = "enova";
      cursorName = "BreezeX-RosePine-Linux";
      cursorSize = 32;
      wallpaper = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/rose-pine/wallpapers/main/blockwavemoon.png";
        hash = "sha256-VenNP2aJ55hU8AfqZ4KHzTkiq+9GveHqL69vgSmRPlE=";
      };
    };
  };
}
