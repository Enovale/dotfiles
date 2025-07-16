{
  config,
  pkgs,
  inputs,
  ...
}:
{
  home.file."${config.programs.nixcord.discord.configDir}/settings.json".force = true;

  programs.nixcord = {
    enable = true;
    discord = {
      enable = true;
      autoscroll.enable = true;
      openASAR.enable = true;
      vencord.enable = false;
      settings = {
        SKIP_HOST_UPDATE = true;
        openasar = {
          setup = true;
          quickstart = true;
        };
        BACKGROUND_COLOR = "#000000";
        DANGEROUS_ENABLE_DEVTOOLS_ONLY_ENABLE_IF_YOU_KNOW_WHAT_YOURE_DOING = true;
        IS_MAXIMIZED = true;
        IS_MINIMIZED = false;
      };
      package = pkgs.discord.override {
        withMoonlight = true;
        moonlight = inputs.moonlight.packages.${pkgs.system}.moonlight;
      };
    };
  };
}
