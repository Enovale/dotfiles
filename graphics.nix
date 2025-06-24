{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.xserver.videoDrivers = [ (if config.systemIsQemu then "qxl" else "amdgpu") ];

  systemd.tmpfiles.rules =
    if config.systemIsQemu then
      [

      ]
    else
      [ "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}" ];

  hardware.graphics.extraPackages = with pkgs; if config.systemIsQemu then [ ] else [ rocmPackages.clr.icd ];

  environment.systemPackages = with pkgs; [
    clinfo
    lact
  ];

  systemd.packages = with pkgs; [ lact ];
  systemd.services.lactd.wantedBy = [ "multi-user.target" ];

  hardware.graphics.enable32Bit = true;

  services.spice-vdagentd.enable = config.systemIsQemu;
  services.qemuGuest.enable = config.systemIsQemu;
}
