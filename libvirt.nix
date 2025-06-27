{ config, ... }:
{
  users.users.enova.extraGroups = [
    "libvirtd"
    "kvm"
  ];

  programs.virt-manager.enable = !config.systemIsQemu;

  users.groups.libvirtd.members = [ "enova" ];

  virtualisation.libvirtd.enable = !config.systemIsQemu;

  virtualisation.spiceUSBRedirection.enable = !config.systemIsQemu;
}
