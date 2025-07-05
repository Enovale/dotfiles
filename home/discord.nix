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

  home.file."${config.home.homeDirectory}/discord/settings.json".text = ''
    {
      "SKIP_HOST_UPDATE": true,
      "openasar": {
        "setup": true,
        "quickstart": true
      },
      "BACKGROUND_COLOR": "#000000",
      "chromiumSwitches": [
        "--enable-zero-copy",
        "--ignore-gpu-blocklist",
        "--enable-native-gpu-memory-buffers",
        "--enable-gpu-rasterization",
        "--enable-features=VaapiVideoDecode,VaapiIgnoreDriverChecks,AcceleratedVideoDecodeLinuxGL,AcceleratedVideoEncoder,WebMachineLearningNeuralNetwork",
        "--enable-raw-draw",
        "--enable-unsafe-webgpu",
        "--enable-blink-features=MiddleClickAutoscroll",
        "--password-store="kwallet6"
      ],
      "DANGEROUS_ENABLE_DEVTOOLS_ONLY_ENABLE_IF_YOU_KNOW_WHAT_YOURE_DOING": true
    }
  '';
}
