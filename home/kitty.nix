{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    enableGitIntegration = true;
    shellIntegration.enableBashIntegration = true;
    shellIntegration.enableZshIntegration = true;
    font = {
      name = "Jetbrains Mono";
      size = 12;
      package = pkgs.jetbrains-mono;
    };

    settings = {
      #background_opacity = 0.75;
      mouse_hide_wait = 0; # disable mouse hiding
      enable_audio_bell = false;
      confirm_os_window_close = 0;
    };

    keybindings = {
      # scroll up/down with (keypad) page up/down
      "ctrl+KP_Prior" = "scroll_page_up";
      "ctrl+KP_Next" = "scroll_page_down";
    };
  };
}
