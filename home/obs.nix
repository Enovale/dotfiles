{ config, pkgs, ... }:
{
  programs.obs-studio = {
    enable = false;

    # optional Nvidia hardware acceleration
    package = (
      pkgs.obs-studio.override {
        cudaSupport = true;
      }
    );

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      waveform
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi #optional AMD hardware acceleration
      obs-gstreamer
      obs-vkcapture
      obs-tuna
      obs-multi-rtmp
      input-overlay
    ];
  };
}
