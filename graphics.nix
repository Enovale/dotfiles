{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.xserver.videoDrivers = [ (if config.systemIsQemu then "qxl" else "amdgpu") ];

  systemd.tmpfiles.rules =
    if !config.systemIsQemu then
      [
        "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
      ]
    else
      [ ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; if !config.systemIsQemu then [ rocmPackages.clr.icd ] else [ ];
  };

  hardware.amdgpu.overdrive.enable = !config.systemIsQemu;

  environment.systemPackages = with pkgs; [
    clinfo
    lact
  ];

  systemd.packages = with pkgs; [ lact ];
  systemd.services.lactd.wantedBy = [ "multi-user.target" ];

  services.spice-vdagentd.enable = config.systemIsQemu;
  services.qemuGuest.enable = config.systemIsQemu;
}
