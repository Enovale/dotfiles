{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    # System Scripts
    (writeShellScriptBin "install-bootloader" ''
      sudo NIXOS_INSTALL_BOOTLOADER=1 /nix/var/nix/profiles/system/bin/switch-to-configuration boot
    '')
    (writeShellScriptBin "switch-nix" ''
      build-nix switch $@
    '')
    (writeShellScriptBin "test-nix" ''
      build-nix test $@
    '')
    (writeShellScriptBin "boot-nix" ''
      build-nix boot $@
    '')
    (writeShellScriptBin "update-switch-nix" ''
      update-nix
      build-nix switch $@
    '')
    (writeShellScriptBin "update-nix" ''
      pushd ~/nixos/ >& /dev/null
      flatpak update --noninteractive
      nix flake update --flake ~/nixos/
      nix run ~/nixos#update
      popd >& /dev/null
    '')
    (writeShellScriptBin "build-nix" ''
      pushd ~/nixos/ >& /dev/null
      nixos-rebuild $1 --flake ~/nixos/ --sudo --impure --log-format internal-json ''${@:2} |& nom --json
      popd >& /dev/null
    '')
    (writeShellScriptBin "repl-nix" ''
      pushd ~/nixos/ >& /dev/null
      nix repl ~/nixos/#nixosConfigurations.crystalline $@
      popd >& /dev/null
    '')
    (writeShellScriptBin "clean-nix" ''
      nix-store --gc $@
    '')
    (writeShellScriptBin "rc2nix" ''
      nix run github:nix-community/plasma-manager $@ > ~/Downloads/plasma-manager.nix
      $EDITOR ~/Downloads/plasma-manager.nix
    '')
    (writeShellScriptBin "reboot-windows" ''
      b=$(efibootmgr | grep Windows)
      sudo ${efibootmgr}/bin/efibootmgr -n ${"b:4:4"} 
      reboot
    '')

    # Fun Scripts
    (writeShellScriptBin "toggle-autoclick" ''
      pid_file=/var/run/user/$(id -u)/autoclicker.sh.pid

      if [ -f $pid_file ]; then
         ${libnotify}/bin/notify-send -u low -h boolean:SWAYNC_BYPASS_DND:true 'Clicking Stopped!'
         kill -INT $(cat $pid_file)
         #killall ydotool
         exit 1
      fi

      trap "rm -f -- '$pid_file'" EXIT
      echo $$ > "$pid_file"

      ${libnotify}/bin/notify-send -u low -h boolean:SWAYNC_BYPASS_DND:true 'Clicking Started!'

      for ((;;)); do
          ${ydotool}/bin/ydotool click -D 25 0xC0
          #ydotool click -r 999999 -D 25 0xC0
      done
    '')
  ];

  systemd.user.services.skinpeek = {
    Unit = {
      Description = "SkinPeek Service.";
      After = [ "network.target" ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "/usr/bin/env bash ${config.home.homeDirectory}/SkinPeek/SkinPeek-nix.sh";
    };
  };

/*
  systemd.user.services.mediamtx = {
    Unit = {
      Description = "MediaMTX Service.";
      After = [ "network.target" ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      Type = "simple";
      Environment = "MTX_SRT=no MTX_RTSP=no MTX_WEBRTC=no MTX_HLSADDRESS=0.0.0.0:8889 MTX_PATHS_ALL_OTHERS_SOURCE=publisher";
      ExecStart = "${pkgs.mediamtx}/bin/mediamtx";
    };
  };
  */
}
