{ config, pkgs, ... }:
{
  imports = [
    ./anyrun.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;

    systemd.enable = true;
    systemd.enableXdgAutostart = true;
  };
  services.hyprpolkitagent.enable = true;
  services.hyprpaper = {
    enable = true;
  };

  home.pointerCursor.hyprcursor = {
    enable = true;
    size = 32;
  };

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [
          "hyprland/workspaces"
          "sway/workspaces"
        ];
        modules-center = [
          "mpris"
        ];
        modules-right = [
          "tray"
          "custom/notification"
          "pulseaudio"
          "cpu"
          "memory"
          "clock"
        ];
        "custom/notification" = {
          tooltip = false;
          format = "{} {icon}";
          # TODO
          format-icons = {
            notification = "n";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          on-click-middle = "swaync-client -C -sw";
          escape = true;
        };
      };
    };
  };

  services.swaync = {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "top";
      control-center-margin-top = 10;
      control-center-margin-bottom = 10;
      control-center-margin-right = 10;
      control-center-margin-left = 10;
      notification-icon-size = 64;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      timeout = 10;
      timeout-low = 5;
      timeout-critical = 0;
      fit-to-screen = false;
      control-center-width = 500;
      control-center-height = 1025;
      notification-window-width = 500;
      keyboard-shortcuts = true;
      image-visibility = "when-available";
      transition-time = 200;
      hide-on-clear = false;
      hide-on-action = true;
      script-fail-notify = true;
      widgets = [
        "title"
        "buttons-grid"
        "mpris"
        "volume"
        "backlight"
        "dnd"
        "notifications"
      ];
      widget-config = {
        title = {
          text = "Notification Center";
          clear-all-button = true;
          button-text = "󰆴 Clear All";
        };
        dnd = {
          text = "Do Not Disturb";
        };
        label = {
          max-lines = 1;
          text = "Notification Center";
        };
        mpris = {
          image-size = 96;
          image-radius = 7;
        };
        volume = {
          label = "󰕾";
        };
        backlight = {
          label = "󰃟";
        };
        buttons-grid = {
          actions = [
            {
              label = "󰐥";
              command = "systemctl poweroff";
            }
            {
              label = "󰜉";
              command = "systemctl reboot";
            }
            {
              label = "";
              command = "nautilus";
            }
            {
              label = "";
              command = "pavucontrol";
            }
            {
              label = "";
              command = "spotify";
            }
            {
              label = "󰕾";
              command = "wpctl set-mute @DEFAULT_SINK@ toggle";
            }
            {
              label = "󰍬";
              command = "pactl set-source-mute @DEFAULT_SOURCE@ toggle";
            }
          ];
        };
      };
    };
    #style = (builtins.readFile ./style.css);
  };

  # Hint Electron apps to use Wayland:
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  wayland.windowManager.hyprland.extraConfig = builtins.readFile ./hyprland.conf;
}
