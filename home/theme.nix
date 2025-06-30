{
  pkgs,
  osConfig,
  nix-colors,
  ...
}:
{
  home.file.".local/share/color-schemes/MaterialYouDark.colors".source = ./MaterialYouDark.colors;

  qt = {
    enable = true;
    platformTheme.name = "qtct";
  };

  gtk = rec {
    enable = true;
    theme = {
      name = "Breeze";
    };

    iconTheme = {
      name = "breeze-dark";
    };

    font = {
      name = "Noto Sans";
      package = pkgs.noto-fonts;
      size = 12;
    };

    gtk2.extraConfig = ''
      gtk-application-prefer-dark-theme=ltrue
      gtk-enable-animations=1
      gtk-primary-button-warps-slider=1
      gtk-toolbar-style=3
      gtk-menu-images=1
      gtk-button-images=1
      gtk-cursor-blink-time=1000
      gtk-cursor-blink=1
      gtk-sound-theme-name="ocean"
    '';

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-decoration-layout = "icon:minimize,maximize,close";
      gtk-enable-animations = true;
      gtk-primary-button-warps-slider = true;
      gtk-sound-theme-name = "ocean";
    };
    gtk4.extraConfig = gtk3.extraConfig;
  };

  #colorScheme = nix-colors.colorSchemes.dracula;

  services.hyprpaper = {
    enable = false;
    settings = {
      ipc = "on";
      splash = true;
      splash_offset = 2.0;

      preload = [ "${osConfig.global.wallpaper}" ];

      wallpaper = [ ",${osConfig.global.wallpaper}" ];
    };
  };

  programs.mpvpaper = {
    enable = false;
    package = pkgs.mpvpaper;
    pauseList = ''obs'';
    stopList = ''obs'';
  };

  services.swww = {
    enable = true;
  };

  home.packages = with pkgs; [
    waypaper
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    noto-fonts-monochrome-emoji
    nerd-fonts.noto
    font-awesome
    roboto
    liberation_ttf
    fira-code
    fira-code-symbols
    jetbrains-mono
  ];

  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [
          "Noto Serif 12pt"
        ];
        sansSerif = [
          "Noto Sans 12pt"
        ];
        monospace = [ "Jetbrains Mono 12pt" ];
        emoji = [ "Noto Monochrome Emoji ${osConfig.global.fontSize}"];
      };
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    hyprcursor.enable = true;
    name = osConfig.global.cursorName;
    size = osConfig.global.cursorSize;
    package = pkgs.rose-pine-cursor;
  };
}
