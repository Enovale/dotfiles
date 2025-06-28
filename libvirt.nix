{ config, global, ... }:
{
  users.users.${config.global.username}.extraGroups = [
    "libvirtd"
    "kvm"
  ];

  programs.virt-manager.enable = !config.systemIsQemu;

  users.groups.libvirtd.members = [ config.global.username ];

  virtualisation.libvirtd.enable = !config.systemIsQemu;

  virtualisation.spiceUSBRedirection.enable = !config.systemIsQemu;
}
