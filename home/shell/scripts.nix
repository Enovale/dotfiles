{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (writeShellScriptBin "rebuild-nix" ''
      extraArgs=''${@}
      if [[ $1 =~ ^(update)$ ]]; then
        nix flake update --flake ~/nixos/
        extraArgs=''${@:2}
      fi

      pushd ~/nixos/ >& /dev/null
      nixos-rebuild switch --flake ~/nixos/ --sudo --impure --log-format internal-json $extraArgs |& nom --json
      popd >& /dev/null
    '')
    (writeShellScriptBin "inspect-nix" ''
      nix repl ~/nixos/#nixosConfigurations.crystalline
    '')
    (writeShellScriptBin "clean-nix" ''
      nix-store --gc
    '')
  ];
}
