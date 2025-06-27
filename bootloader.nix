{ config, lib, ... }:
{
  options = {
    ellie.bootloader = lib.mkOption {
      type = lib.types.enum [
        "systemd-boot"
        "grub"
      ];
      default = "grub";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (config.ellie.bootloader == "systemd-boot") {
      boot.loader = {
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot"; # ← use the same mount point here.
        };
        systemd-boot = {
          enable = true;
        };
      };
    })
    (lib.mkIf (config.ellie.bootloader == "grub") {
      boot.loader = {
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot"; # ← use the same mount point here.
        };
        grub = {
          enable = true;
          useOSProber = true;
          copyKernels = true;
          efiSupport = true;
          fsIdentifier = "label";
          devices = [ "nodev" ];
          extraEntries = ''
            menuentry "Reboot" {
                reboot
            }
            menuentry "Poweroff" {
                halt
            }
          '';
        };
      };
    })
  ];
}
