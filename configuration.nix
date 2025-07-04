{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    "${builtins.getEnv "PWD"}/hardware-configuration.nix"
    ./bootloader.nix
    ./sddm.nix
    ./hyprland.nix
    ./programs.nix
    ./steam
    ./slskd.nix
    ./graphics.nix
    ./libvirt.nix
  ];

  nix = {
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    optimise = {
      automatic = true;
    };
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 4d";
    };
    extraOptions = ''
      min-free = ${toString (5 * 1024 * 1024 * 1024)}
      max-free = ${toString (10 * 1024 * 1024 * 1024)}
    '';
    settings = {
      max-jobs = 2;
      cores = 6;
      download-buffer-size = 524288000;
      warn-dirty = false;
      trusted-users = [ "@wheel" ];
      substituters = [
        "https://hyprland.cachix.org"
        "https://anyrun.cachix.org"
        "https://nix-community.cachix.org"
        "https://nixpkgs-wayland.cachix.org"
        "https://niri.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      ];
    };
  };

  system.activationScripts.preActivation = ''
    if [[ -e /run/current-system ]]; then
      echo "--- diff to current-system"
      ${pkgs.expect}/bin/unbuffer ${pkgs.nvd}/bin/nvd --nix-bin-dir=${config.nix.package}/bin diff /run/current-system "$systemConfig"
      echo "---"
    fi
  '';

  # Bootloader
  enova.bootloader = "grub";

  boot = {
    tmp.cleanOnBoot = true;
    kernelPackages = pkgs.linuxPackages_zen;

    plymouth = {
      enable = true;
      theme = "blahaj";
      themePackages = with pkgs; [
        plymouth-blahaj-theme
      ];
    };

    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    #loader.timeout = 0;
  };

  networking = {
    hostName = "crystalline";
    firewall.enable = false;
    # These options are unnecessary when managing DNS ourselves
    useDHCP = false;
    dhcpcd.enable = false;
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "8.8.8.8"
      "8.0.0.8"
    ];
    networkmanager = {
      enable = true;
      dns = "none";
    };
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  programs.dconf.enable = true;

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  # DO NOT disable if you need accelerated XWayland support
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.desktopManager.plasma6 = {
    enable = true;
    enableQt5Integration = true;
  };

  security.pam.services.sudo.nodelay = true;
  security.pam.services.login.kwallet.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    konsole
    elisa
    khelpcenter
    krunner
  ];

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      kdePackages.xdg-desktop-portal-kde
    ];
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
    options = "caps:super";
  };
  console.useXkbConfig = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${config.global.username} = {
    isNormalUser = true;
    description = "Enova";
    shell = pkgs.zsh;
    extraGroups = [
      "adbusers"
      "corectrl"
      config.programs.ydotool.group
      "networkmanager"
      "wheel"
    ];
  };

  security.sudo.wheelNeedsPassword = false;
  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("users")
          && (
            action.id == "org.freedesktop.login1.reboot" ||
            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
            action.id == "org.freedesktop.login1.power-off" ||
            action.id == "org.freedesktop.login1.power-off-multiple-sessions"
          )
        )
      {
        return polkit.Result.YES;
      }
    });
  '';

  nixpkgs = {
    config = {
      allowUnfree = true;
      android_sdk.accept_license = true;
      permittedInsecurePackages = [ "dotnet-runtime-7.0.20" ];
    };
    overlays = [ inputs.nur.overlays.default ];
  };

  environment.pathsToLink = [ "/share/zsh" ];

  fonts = {
    enableDefaultPackages = true;
    enableGhostscriptFonts = true;
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  programs.corectrl = {
    enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.xwayland.enable = true;
  programs.zsh.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = if !config.systemIsQemu then (32 * 1024) else (4 * 1024);
    }
  ];
  zramSwap.enable = true; # Creates a zram block device and uses it as a swap device

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
