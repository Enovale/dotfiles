{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.gpu-screen-recorder.ui;
  package = cfg.package.override {
    inherit (config.security) wrapperDir;
  };
in
{
  options = {
    programs.gpu-screen-recorder.ui = {
      package = lib.mkOption {
        default = pkgs.callPackage ./package.nix { };
      };
      notificationPackage = lib.mkOption {
        default = pkgs.callPackage ./notification.nix { };
      };

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to install gpu-screen-recorder-ui and generate setcap
          wrappers for promptless recording.
        '';
      };

      systemd.target = lib.mkOption {
        type = lib.types.str;
        description = ''
          The systemd target that will automatically start the gsr-ui service.
        '';
        default = "graphical-session.target";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    security.wrappers."gsr-global-hotkeys" = {
      owner = "root";
      group = "root";
      capabilities = "cap_setuid+ep";
      source = "${package}/bin/gsr-global-hotkeys";
    };

    environment.systemPackages = [
      package
      cfg.notificationPackage
    ];

    systemd = {
      packages = [ package ];
      user.services.gpu-screen-recorder-ui.wantedBy = [ cfg.systemd.target ];
    };
  };

  meta.maintainers = with lib.maintainers; [ enova ];
}
