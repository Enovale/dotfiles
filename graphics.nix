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
      [
        "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
      ]
    else
      [ ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages =
      with pkgs;
      if !config.systemIsQemu then
        [
          libvdpau-va-gl
        ]
      else
        [ ];
  };

  programs.gamemode = {
    enable = true;
  };

  hardware.amdgpu =
    if !config.systemIsQemu then
      {
        initrd.enable = true;
        overdrive.enable = true;
        opencl.enable = true;
        amdvlk.enable = false;
      }
    else
      { };

  environment.systemPackages = with pkgs; [
    clinfo
    lact
  ];

  systemd.packages = with pkgs; [ lact ];
  systemd.services.lactd.wantedBy = [ "multi-user.target" ];

  services.spice-vdagentd.enable = config.systemIsQemu;
  services.qemuGuest.enable = config.systemIsQemu;
}
