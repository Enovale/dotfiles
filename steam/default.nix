{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [ ./vr ];

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  nixpkgs.overlays = with inputs; [
    millennium.overlays.default
  ];

  programs.java = {
    enable = true;
    #package = pkgs.jdk;
    binfmt = true;
  };

  programs.steam = {
    enable = true;
    package = pkgs.steam-millennium;
    protontricks.enable = true;

    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    extraCompatPackages = with pkgs; [
      proton-ge-bin
      (pkgs.callPackage ./northstar-proton.nix { })
      (pkgs.callPackage ./boson.nix { })
    ];
  };
}
