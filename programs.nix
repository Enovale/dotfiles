{
  config,
  pkgs,
  ...
}:
{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages =
    with pkgs;
    [
      nix-output-monitor
      git
      wget
      mpv
      vlc
      qbittorrent
      nixfmt-rfc-style
      gpu-screen-recorder
      firefoxpwa
      wineWowPackages.staging
      wineWowPackages.waylandFull
      winetricks
      protontricks
      protonup-qt
      gamescope
      kdePackages.xdg-desktop-portal-kde
    ]
    ++ (
      if config.systemIsQemu then
        [ ]
      else
        # Don't want to include very large packages in a light env
        [
          jetbrains.rider
          jetbrains.rust-rover
          jetbrains.clion
          jetbrains.pycharm-community
          android-udev-rules
          android-tools
          android-studio
        ]
    );

  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  programs.ydotool.enable = true;
}
