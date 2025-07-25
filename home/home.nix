{
  inputs,
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  oldJetbrainsPkgs =
    (import (fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/tarball/9807714d6944a957c2e036f84b0ff8caf9930bc0";
      sha256 = "sha256:1g9qc3n5zx16h129dqs5ixfrsff0dsws9lixfja94r208fq9219g";
    }))
      {
        config.allowUnfree = true;
        localSystem.system = "x86_64-linux";
      };
in
{
  imports = [
    ./plasma.nix
    ./hyprland
    ./kitty.nix
    ./discord.nix
    ./default_apps.nix
    ./theme.nix
    ./git.nix
    ./kidex.nix
    ./browser.nix
    ./shell
  ];

  home.packages =
    with pkgs;
    [
      btrfs-assistant
      ripsecrets
      wget
      icu
      mpv
      comma
      vlc
      wayland-utils
      wl-clipboard
      qbittorrent
      nixfmt-rfc-style
      firefoxpwa
      winetricks
      protonup-qt
      qpwgraph
      acpi
      nixd
      schismtracker
      renoise
      feh
      file
      signal-desktop
      cinny-desktop
      strawberry
      oldJetbrainsPkgs.tauon
      zsh-powerlevel10k
      lutris
      josm
      lxqt.pavucontrol-qt
      tree
      gale
      gamescope
      songrec
      avidemux
      fcast-receiver
      hydroxide
      linux-wallpaperengine
      jdownloader2
      media-fetcher
      nix-inspect
    ]
    ++ (lib.optionals (!osConfig.systemIsQemu)
      # Don't want to include very large packages in a light env
      [
        audacity
        teamspeak6-client
        ardour
        easytag
        kid3-kde
        gimp3-with-plugins
        inkscape
        scanmem
        iaito
        (prismlauncher.override {
          jdks = [
            jdk8
            jdk17
            jdk21
            jdk
          ];
        })
        libreoffice
        libresprite
        wineWowPackages.waylandFull
        blender
        godot-mono
        oldJetbrainsPkgs.jetbrains.rider
        oldJetbrainsPkgs.jetbrains.rust-rover
        oldJetbrainsPkgs.jetbrains.clion
        oldJetbrainsPkgs.jetbrains.pycharm-community
        oldJetbrainsPkgs.jetbrains.idea-community
        oldJetbrainsPkgs.android-studio
        android-udev-rules
        android-tools
        scrcpy
        osu-lazer-bin
        vintagestory
        wlx-overlay-s
        (xivlauncher-rb.override { useGameMode = true; })
      ]
    );

  services.kdeconnect.enable = true;
  services.kdeconnect.indicator = true;
  services.playerctld.enable = true;

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
  };

  home.sessionVariables = {
    COMPLETION_WAITING_DOTS = "true";
    EDITOR = "kate";
    MOZ_USE_XINPUT2 = "1";
    _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd";
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
      xdg-desktop-portal-luminous
      xdg-desktop-portal-hypr-remote
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
          "hyprland"
          "wlr"
          "kde"
          "gtk"
          "hypr-remote"
        ];
        "org.freedesktop.impl.portal.Settings" = [
          "kde"
        ];
        "org.freedesktop.impl.portal.Screencast" = [
          "hyprland"
        ];
        "org.freedesktop.impl.portal.RemoteDesktop" = [
          "wlr"
          #"hypr-remote"
          #"luminous"
        ];
        "org.freedesktop.impl.portal.FileChooser" = [
          "kde"
        ];
      };
    };
  };

  programs.bash.enable = true;
  programs.bat.enable = true;
  programs.htop.enable = true;
  programs.ripgrep.enable = true;

  programs.mangohud = {
    enable = true;
    enableSessionWide = true;
    settings = {
      no_display = true;
    };
  };

  # Hint Electron apps to use Wayland:
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  xdg.configFile."gpu-screen-recorder/config_ui".source = ./gsr-ui.conf;

  xdg.configFile."wireplumber/main.lua.d/99-stop-microphone-auto-adjust.lua".text = ''
    table.insert (default_access.rules,{
        matches = {
            {
                { "application.process.binary", "=", "electron" },
                { "application.process.binary", "=", "chromium" },
                { "application.process.binary", "=", "discord" }
            }
        },
        default_permissions = "rx",
    })
  '';

  home.stateVersion = "25.05";
}
