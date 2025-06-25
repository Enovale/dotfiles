{ config, pkgs, ... }:
{
  programs.kitty.enable = true;
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

  # Hint Electron apps to use Wayland:
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  wayland.windowManager.hyprland.extraConfig = builtins.readFile ./hyprland.conf;
}
