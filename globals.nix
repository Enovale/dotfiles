{ config, lib, ... }:
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
        };
      };
    };
  };

  config = {
    global = {
      username = "enova";
    };
  };
}
