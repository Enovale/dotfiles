{
  config,
  pkgs,
  lib,
  ...
}:
{

  imports = [
    ./hyprland
    ./discord.nix
    ./theme.nix
    ./git.nix
  ];

  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "rebuild-nix" ''
      #!/usr/bin/env bash

      nixos-rebuild switch --flake ~/nixos/ --sudo --log-format internal-json $@ |& nom --json
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
    kdePackages.kate
    (xivlauncher-rb.override { useGameMode = true; })
  ];

  programs.zsh = {
    enable = true;
    initContent = lib.mkAfter ''source "${./p10k.zsh}"'';
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

  programs.firefox = {
    enable = true;
    package = pkgs.librewolf;

    nativeMessagingHosts = [ pkgs.firefoxpwa ];
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableProfileImport = true;
      OfferToSaveLogins = false;
      Preferences = {
        "cookiebanners.service.mode.privateBrowsing" = 2; # Block cookie banners in private browsing
        "cookiebanners.service.mode" = 2; # Block cookie banners
        "network.cookie.lifetimePolicy" = 0;
        "identity.fxaccounts.enabled" = true;
        "privacy.donottrackheader.enabled" = true;
        "privacy.fingerprintingProtection" = true;
        "privacy.resistFingerprinting" = true;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.cookies" = false;
        "privacy.trackingprotection.emailtracking.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.fingerprinting.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "webgl.disabled" = false;
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "widget.use-xdg-desktop-portal.location" = 1;
        "widget.use-xdg-desktop-portal.mime-handler" = 1;
        "widget.use-xdg-desktop-portal.open-uri" = 1;
        "widget.use-xdg-desktop-portal.settings" = 1;
      };
      ExtensionSettings = {
        "jid1-ZAdIEUB7XOzOJw@jetpack" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/duckduckgo-for-firefox/latest.xpi";
          installation_mode = "force_installed";
        };
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        "addon@darkreader.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "force_installed";
        };
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
        "deArrow@ajay.app" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/dearrow/latest.xpi";
          installation_mode = "force_installed";
        };
        "sponsorBlocker@ajay.app" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
          installation_mode = "force_installed";
        };
        "{6e710c58-36cc-49d6-b772-bfc3030fa56e}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/xkit-rewritten/latest.xpi";
          installation_mode = "force_installed";
        };
        "{b86e4813-687a-43e6-ab65-0bde4ab75758}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/localcdn-fork-of-decentraleyes/latest.xpi";
          installation_mode = "force_installed";
        };
        "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/return-youtube-dislikes/latest.xpi";
          installation_mode = "force_installed";
        };
        "{cb31ec5d-c49a-4e5a-b240-16c767444f62}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/indie-wiki-buddy/latest.xpi";
          installation_mode = "force_installed";
        };
        "firefox-addon@pronoundb.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/pronoundb/latest.xpi";
          installation_mode = "force_installed";
        };
        "{b5501fd1-7084-45c5-9aa6-567c2fcf5dc6}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ruffle_rs/latest.xpi";
          installation_mode = "force_installed";
        };
        "firefoxpwa@filips.si" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/pwas-for-firefox/latest.xpi";
          installation_mode = "force_installed";
        };
        "myallychou@gmail.com" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/youtube-recommended-videos/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  home.stateVersion = "25.05";
}
