{
  config,
  pkgs,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    goofcord
    legcord
  ];
  programs.nixcord = {
    enable = false;
    config = {
      #themeLinks = with config.catppuccin; [
      #  "https://catppuccin.github.io/discord/dist/#catppuccin-${flavor}-${accent}.theme.css"
      #];
    };

    discord.autoscroll.enable = true;
  };
}
