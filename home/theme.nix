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

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    hyprcursor.enable = true;
    name = osConfig.global.cursorName;
    size = osConfig.global.cursorSize;
    package = pkgs.rose-pine-cursor;
  };
}
