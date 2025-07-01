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
      gpu-screen-recorder
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
    EDITOR = "nano";
    MOZ_USE_XINPUT2 = "1";
    _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd";
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
        "org.freedesktop.impl.portal.Screencast" = [
          "hyprland"
          "wlr"
        ];
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

  programs.bash.enable = true;
  programs.bat.enable = true;
  programs.htop.enable = true;
  programs.ripgrep.enable = true;

  programs.mangohud = {
    enable = true;
    enableSessionWide = true;
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  home.file."${config.home.homeDirectory}/.gtkrc-2.0".force = lib.mkForce true;

  home.stateVersion = "25.05";
}
