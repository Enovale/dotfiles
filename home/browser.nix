{ config, pkgs, ... }:
{
  programs.librewolf = {
    enable = true;
    #package = pkgs.librewolf;

    nativeMessagingHosts = [
      pkgs.firefoxpwa
      pkgs.kdePackages.plasma-browser-integration
    ];
    profiles.default = {
      containersForce = true;
      bookmarks = {
        force = true;
        settings = [
          {
            # TODO Categorize?
            name = "Misc";
            toolbar = true;
            bookmarks = [
              {
                name = "nightride";
                tags = [
                  "music"
                  "radio"
                ];
                url = "https://nightride.fm/";
              }
            ];
          }
          "separator"
          {
            name = "Nix sites";
            toolbar = true;
            bookmarks = [
              {
                name = "homepage";
                tags = [ "nix" ];
                url = "https://nixos.org/";
              }
              {
                name = "nixpkgs";
                tags = [
                  "packages"
                  "nix"
                ];
                url = "https://search.nixos.org/";
              }
              {
                name = "hm-options";
                tags = [
                  "packages"
                  "nix"
                ];
                url = "https://home-manager-options.extranix.com/";
              }
              {
                name = "nur-pkgs";
                tags = [
                  "packages"
                  "nix"
                ];
                url = "https://nur.nix-community.org/";
              }
              {
                name = "wiki";
                tags = [
                  "wiki"
                  "nix"
                ];
                url = "https://wiki.nixos.org/";
              }
            ];
          }
        ];
      };
      search = {
        force = true;
        order = [
          "ddg"
          "google"
        ];
        engines = {
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };
          "Nix Options" = {
            definedAliases = [ "@no" ];
            urls = [
              {
                template = "https://search.nixos.org/options";
                params = [
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
          };
        };
      };
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        plasma-integration
        canvasblocker
        ublock-origin
        duckduckgo-privacy-essentials
        bitwarden
        pronoundb
        pwas-for-firefox
        darkreader
        return-youtube-dislikes
        sponsorblock
        dearrow
        youtube-recommended-videos
        ruffle_rs
        indie-wiki-buddy
        xkit-rewritten
        localcdn
        istilldontcareaboutcookies
        cookie-quick-manager
        proton-vpn
        shinigami-eyes
        widegithub
        wayback-machine
        twitch-auto-points
        github-file-icons
      ];
      settings = {
        "general.autoscroll" = true;
        "browser.tabs.inTitlebar" = 0;
        "extensions.autoDisableScopes" = 0;
        "cookiebanners.service.mode.privateBrowsing" = 2; # Block cookie banners in private browsing
        "cookiebanners.service.mode" = 2; # Block cookie banners
        "network.cookie.lifetimePolicy" = 0;
        "identity.fxaccounts.enabled" = true;
        "privacy.donottrackheader.enabled" = true;
        "privacy.fingerprintingProtection" = true;
        "privacy.resistFingerprinting" = true;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.cookies" = false;
        "privacy.clearOnShutdown_v2.cache" = false;
        "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
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
        "browser.cache.disk.parent_directory" = "/run/user/1000/librewolf";
      };
    };
    policies = {
      NoDefaultBookmarks = false;
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableProfileImport = true;
      OfferToSaveLogins = false;
    };
  };
}
