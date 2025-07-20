{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.xserver.videoDrivers = [ (if config.systemIsQemu then "qxl" else "amdgpu") ];

  systemd.tmpfiles.rules =
    let
      rocmEnv = pkgs.symlinkJoin {
        name = "rocm-combined";
        paths = with pkgs.rocmPackages; [
          rocblas
          hipblas
          clr
        ];
      };
    in
    lib.optional (!config.systemIsQemu) "L+    /opt/rocm   -    -    -     -    ${rocmEnv}";

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = lib.optional (!config.systemIsQemu) pkgs.libvdpau-va-gl;
  };

  programs.gamemode = {
    enable = true;
  };

  environment.sessionVariables = {
    VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/radeon_icd.i686.json";

    # Hint video encoding to use radeon
    VDPAU_DRIVER = "radeonsi";
  };

  hardware.amdgpu = lib.optionalAttrs (!config.systemIsQemu) {
    initrd.enable = true;
    overdrive.enable = true;
    opencl.enable = true;
    amdvlk.enable = false;
  };

  environment.systemPackages = with pkgs; [
    clinfo
    lact
  ];

  systemd.packages = with pkgs; [ lact ];
  systemd.services.lactd.wantedBy = [ "multi-user.target" ];

  services.spice-vdagentd.enable = config.systemIsQemu;
  services.qemuGuest.enable = config.systemIsQemu;
}
