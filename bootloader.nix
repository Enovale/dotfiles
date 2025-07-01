{ config, lib, ... }:
{
  options = {
    enova.bootloader = lib.mkOption {
      type = lib.types.enum [
        "systemd-boot"
        "grub"
      ];
      default = "grub";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (config.enova.bootloader == "systemd-boot") {
      boot.loader = {
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/efi"; # ← use the same mount point here.
        };
        systemd-boot = {
          enable = true;
        };
      };
    })
    (lib.mkIf (config.enova.bootloader == "grub") {
      boot.loader = {
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/efi"; # ← use the same mount point here.
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
          mirroredBoots =
            with config.boot.loader;
            lib.mkForce [
              {
                path = "/nix/state/booloader";
                devices = if grub.device != "" then [ grub.device ] else grub.devices;
                inherit (config.boot.loader.efi) efiSysMountPoint;
              }
            ];
        };
      };
    })
  ];
}
