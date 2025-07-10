{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:
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
      wget
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
      zsh-powerlevel10k
      lutris
      josm
      lxqt.pavucontrol-qt
      prismlauncher
      tree
      gale
      gamescope
      songrec
      avidemux
      fcast-receiver
      linux-wallpaperengine
      (callPackage ./jdownloader.nix { })
      (callPackage ./media-fetcher.nix { })
    ]
    ++ (
      if !osConfig.systemIsQemu then
        # Don't want to include very large packages in a light env
        [
          audacity
          ardour
          easytag
          kid3-kde
          gimp3-with-plugins
          inkscape
          scanmem
          iaito
          libreoffice
          libresprite
          wineWowPackages.waylandFull
          blender
          godot-mono
          jetbrains.rider
          jetbrains.rust-rover
          jetbrains.clion
          jetbrains.pycharm-community
          jetbrains.idea-community
          android-udev-rules
          android-tools
          scrcpy
          android-studio
          osu-lazer-bin
          vintagestory
          wlx-overlay-s
          (xivlauncher-rb.override { useGameMode = true; })
        ]
      else
        [ ]
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
      (callPackage ./xdg-desktop-portal-hypr-remote.nix { })
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

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
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
