{ pkgs, ... }:
{
  home.packages = with pkgs; [
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
      nix flake update --flake ~/nixos/
      popd >& /dev/null
    '')
    (writeShellScriptBin "build-nix" ''
      pushd ~/nixos/ >& /dev/null
      nixos-rebuild $1 --flake ~/nixos/ --sudo --impure --log-format internal-json ''${@:2} |& nom --json
      popd >& /dev/null
    '')
    (writeShellScriptBin "inspect-nix" ''
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
      sudo ${efibootmgr}/bin/efibootmgr -n ${b:4:4} 
      reboot
    '')
  ];
}
