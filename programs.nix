{
  config,
  inputs,
  pkgs,
  ...
}:
{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    kdePackages.qtmultimedia
    kdePackages.sddm-kcm
    kdePackages.plymouth-kcm
    sddm-astronaut
    expect
    nix-output-monitor
    nvd
    nodePackages.node2nix
    git
    btrfs-progs
    #(inputs.nixpkgs_blender.legacyPackages."x86_64-linux".blender.overrideAttrs (finalAttrs: {
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

  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  programs.ydotool.enable = true;
}
