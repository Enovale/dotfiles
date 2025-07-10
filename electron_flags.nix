{
  lib,
  ...
}:
let
  chromiumFlags = ''
    --enable-zero-copy \
    --ignore-gpu-blocklist \
    --enable-native-gpu-memory-buffers \
    --enable-gpu-rasterization \
    --enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoEncoder,AcceleratedVideoEncoder,Vulkan,VulkanFromANGLE,DefaultANGLEVulkan,VaapiIgnoreDriverChecks,VaapiVideoDecoder,PlatformHEVCDecoderSupport,UseMultiPlaneFormatForHardwareVideo,WebMachineLearningNeuralNetwork \
    --enable-unsafe-webgpu \
    --enable-blink-features=MiddleClickAutoscroll \
    --password-store="kwallet6" \
  '';
in
{
  nixpkgs.overlays = [
    (final: prev: {
      #goofcord = prev.goofcord.override { commandLineArgs = chromiumFlags; };
      #legcord = prev.legcord.override { commandLineArgs = chromiumFlags; };
      vscodium = prev.vscodium.override { commandLineArgs = chromiumFlags; };
      chromium = prev.chromium.override { commandLineArgs = chromiumFlags; };
      signal-desktop = prev.signal-desktop.override { commandLineArgs = chromiumFlags; };
      #cinny-desktop = prev.cinny-desktop.override { commandLineArgs = chromiumFlags; };
      vesktop = prev.vesktop.override { commandLineArgs = chromiumFlags; };
      element-desktop = prev.element-desktop.override { commandLineArgs = chromiumFlags; };
      #electron = prev.electron.override { commandLineArgs = chromiumFlags; };
    })
  ];
}
