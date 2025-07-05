{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./gpu-screen-recorder-ui
    ./electron_flags.nix
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    kdePackages.qtmultimedia
    kdePackages.plymouth-kcm
    expect
    nix-output-monitor
    nvd
    nodePackages.node2nix
    git
    btrfs-progs
    pulseaudio
    inputs.erosanix.packages.${system}.foobar2000
    #(inputs.nixpkgs_blender.legacyPackages.${pkgs.stdenv.hostPlatform.system}.blender.overrideAttrs (finalAttrs: {
    #  version = "3.3.21";
    #  src = fetchzip {
    #   name = "source";
    #    url = "https://download.blender.org/source/blender-${finalAttrs.version}.tar.xz";
    #    hash = "sha256-9VFFBS/ioaTURr5ZriJ2QJud03fG7f/OnfztPVpIYNk=";
    #  };
    #  blenderExecutable = builtins.replaceStrings ["/bin/blender"] ["/bin/blender-3.3"] finalAttrs.blenderExecutable;
    #  postFixup = builtins.replaceStrings ["/bin/blender"] ["/bin/blender-3.3"] finalAttrs.postFixup;
    #}))
  ];

  programs.gpu-screen-recorder = {
    enable = true;
    ui = {
      enable = true;
    };
  };

  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  programs.ydotool.enable = true;

  programs.partition-manager = {
    enable = true;
  };
}
