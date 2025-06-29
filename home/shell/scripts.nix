{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (writeShellScriptBin "rebuild-nix" ''
      #!/usr/bin/env bash

      extraArgs=''${@}
      if [[ $1 =~ ^(update)$ ]]; then
        nix flake update --flake ~/nixos/
        extraArgs=''${@:2}
      fi

      nixos-rebuild switch --flake ~/nixos/ --sudo --log-format internal-json $extraArgs |& nom --json
    '')
    (writeShellScriptBin "inspect-nix" ''
      #!/usr/bin/env bash

      nix repl ~/nixos/#nixosConfigurations.crystalline
    '')
    (writeShellScriptBin "clean-nix" ''
      #!/usr/bin/env bash

      nix-store --gc
    '')
  ];
}
