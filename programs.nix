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
      nodePackages.node2nix
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
      wlx-overlay-s
      scrcpy
      songrec
      avidemux
      audacity
      ardour
      easytag
      kid3-kde
      fcast-receiver
      qpwgraph
      blender
      (blender.overrideAttrs rec {
        version = "3.3.21";
        src = fetchzip {
          name = "source";
          url = "https://download.blender.org/source/blender-${version}.tar.xz";
          hash = "sha256-H9aiBnwTMlcCn8DJOAlYD5/LtjZVVExIecNIfCmf8vQ=";
        };
      })
      (callPackage ./jdownloader.nix { })
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
