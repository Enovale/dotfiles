{ config, lib, ... }:
{
  options = {
    systemIsQemu = lib.mkOption {
      type = lib.types.bool;
      readOnly = true;
    };
  };

  config = {
    systemIsQemu = (
      builtins.any (x: lib.hasPrefix "virtio" x) config.boot.initrd.availableKernelModules
    );
  };
}
