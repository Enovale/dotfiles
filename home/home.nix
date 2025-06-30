{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:
let 
  flags = ''
    --enable-zero-copy
    --ignore-gpu-blocklist
    --enable-native-gpu-memory-buffers
    --enable-gpu-resterization
    --enable-features=VaapiVideoDecode,VaapiIgnoreDriverChecks,AcceleratedVideoDecodeLinuxGL,AcceleratedVideoEncoder
    --enable-raw-draw
    --enable-unsafe-webgpu
    --enable-blink-features=MiddleClickAutoscroll
    --password-store="kwallet6"
  '';
in
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
      jetbrains.idea-community
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
          libreoffice
          wineWowPackages.waylandFull
          blender
          godot-mono
          jetbrains.rider
          jetbrains.rust-rover
          jetbrains.clion
          jetbrains.pycharm-community
          android-udev-rules
          android-tools
          scrcpy
          android-studio
          osu-lazer-bin
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

  # TODO This should probably be in browser.nix
  xdg.configFile."electron-flags.conf".text = flags;
  xdg.configFile."discord-flags.conf".text = flags;
  xdg.configFile."chromium-flags.conf".text = flags;
  xdg.configFile."element-flags.conf".text = flags;
  xdg.configFile."goofcord-flags.conf".text = flags;
  xdg.configFile."vesktop-flags.conf".text = flags;
  xdg.configFile."equibop-flags.conf".text = flags;

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
