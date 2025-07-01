{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (writeShellScriptBin "rebuild-nix" ''
      extraArgs=''${@}
      if [[ $1 =~ ^(update)$ ]]; then
        nix flake update --flake ~/nixos/
        extraArgs=''${@:2}
      fi

      nixos-rebuild switch --flake ~/nixos/ --sudo --log-format internal-json $extraArgs |& nom --json
    '')
    (writeShellScriptBin "inspect-nix" ''
      nix repl ~/nixos/#nixosConfigurations.crystalline
    '')
    (writeShellScriptBin "clean-nix" ''
      nix-store --gc
    '')
  ];
}
