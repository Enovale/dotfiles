{
  config,
  pkgs,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    (discord.override {
      #withVencord = true;
      #vencord = equicord;
      withOpenASAR = true;
      withMoonlight = true;
      enableAutoscroll = true;
    })
  ];

  xdg.configFile."discord/settings.json".text = ''
    {
      "SKIP_HOST_UPDATE": true,
      "openasar": {
        "setup": true,
        "quickstart": true
      },
      "BACKGROUND_COLOR": "#000000",
      "chromiumSwitches": {},
      "DANGEROUS_ENABLE_DEVTOOLS_ONLY_ENABLE_IF_YOU_KNOW_WHAT_YOURE_DOING": true,
      "IS_MAXIMIZED": true,
      "IS_MINIMIZED": false
    }
  '';
}
