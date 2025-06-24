{ pkgs, ... }:
{
  users.users.enova.extraGroups = [ "libvirtd" "kvm" ];

  programs.virt-manager.enable = true;

  users.groups.libvirtd.members = [ "enova" ];

  virtualisation.libvirtd.enable = true;

  virtualisation.spiceUSBRedirection.enable = true;
}
