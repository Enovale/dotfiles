{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./electron_flags.nix
    ./dotnet.nix
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    kdePackages.qtmultimedia
    kdePackages.plymouth-kcm
    kdePackages.krdp
    expect
    nix-output-monitor
    nvd
    unrar
    nodePackages.node2nix
    git
    btrfs-progs
    pulseaudio
    pkgsi686Linux.gperftools
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

  environment.localBinInPath = true;

  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  programs.nix-ld.enable = true;

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
