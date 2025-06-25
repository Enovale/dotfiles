{
  config,
  pkgs,
  lib,
  ...
}:
{

  imports = [
    ./plasma.nix
    ./hyprland
    ./discord.nix
    ./theme.nix
    ./git.nix
    ./browser.nix
  ];

  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "rebuild-nix" ''
      #!/usr/bin/env bash

      if [[ $1 =~ ^(update)$ ]]; then
        nix flake update --flake ~/nixos/
      fi

      nixos-rebuild switch --flake ~/nixos/ --sudo --log-format internal-json ''${@:2} |& nom --json
    '')
    acpi
    nixd
    feh
    file
    vscodium
    signal-desktop
    cinny-desktop
    strawberry
    zsh-powerlevel10k
    libreoffice
    lutris
    osu-lazer-bin
    lxqt.pavucontrol-qt
    prismlauncher
    tree
    gimp3-with-plugins
    (xivlauncher-rb.override { useGameMode = true; })
  ];

  services.kdeconnect.enable = true;
  services.kdeconnect.indicator = true;

  programs.zsh = {
    enable = true;
    initContent = lib.mkAfter ''source "${./p10k.zsh}"; export ZSH_HIGHLIGHT_STYLES[comment]="fg=8"'';
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
      ];
    };
  };
  home.sessionVariables = {
    COMPLETION_WAITING_DOTS = "true";
    EDITOR = "nano";
    MOZ_USE_XINPUT2 = "1";
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
      xdg-desktop-portal-shana
      xdg-desktop-portal-luminous
      kdePackages.xdg-desktop-portal-kde
    ];
    config = {
      common = {
        default = [
          "kde"
          "gtk"
        ];
      };
      hyprland = {
        default = [
          "shana"
          "hyprland"
          "wlr"
          "kde"
          "gtk"
        ];
        "org.freedesktop.impl.portal.Settings" = [
          "gtk"
        ];
        #"org.freedesktop.impl.portal.Screencast" = [
        #  "wlr"
        #];
        "org.freedesktop.impl.portal.RemoteDesktop" = [
          "wlr"
          "luminous"
        ];
        "org.freedesktop.impl.portal.FileChooser" = [
          "kde"
        ];
      };
    };
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "${config.home.homeDirectory}/nixos";
  };

  programs.bash.enable = true;
  programs.bat.enable = true;
  programs.htop.enable = true;
  programs.mangohud.enable = true;
  programs.ripgrep.enable = true;

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  home.stateVersion = "25.05";
}
