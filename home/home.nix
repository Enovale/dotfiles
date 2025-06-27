{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:
{
  imports = [
    ./shell_scripts.nix
    ./plasma.nix
    ./hyprland
    ./kitty.nix
    ./discord.nix
    ./theme.nix
    ./git.nix
    ./kidex.nix
    ./browser.nix
  ];

  home.packages =
    with pkgs;
    [
      btrfs-assistant
      wget
      mpv
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
      vscodium
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

  programs.zsh = {
    enable = true;
    initContent = lib.mkAfter ''source "${./p10k.zsh}"; export ZSH_HIGHLIGHT_STYLES[comment]="fg=8"'';
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
        };
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
