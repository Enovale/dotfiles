{
  description = "NixOS Configuration Flake";

  inputs = {
    # This is pointing to an unstable release.
    # If you prefer a stable release instead, you can this to the latest number shown here: https://nixos.org/download
    # i.e. nixos-24.11
    # Use `nix flake update` to update the flake to the latest revision of the chosen release channel.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs_blender.url = "github:NixOS/nixpkgs/d09843bf11098b696fc2831f47287369745c6a56";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    erosanix.url = "github:emmanuelrosa/erosanix";

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    # Replacement for ls
    eza = {
      url = "github:eza-community/eza";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
      };
    };

    # Prebuilt package index - provides comma package
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";

    hyprland.url = "github:hyprwm/Hyprland";

    anyrun.url = "github:anyrun-org/anyrun";

    nixos-xivlauncher-rb = {
      url = "github:ProverbialPennance/nixos-xivlauncher-rb";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    naersk.url = "github:nix-community/naersk";

    gpu-screen-recorder-ui.url = "github:Enovale/gsrui-nix";

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    import-tree.url = "github:vic/import-tree";
    flake-parts.url = "github:hercules-ci/flake-parts";

    kidex.url = "github:Kirottu/kidex";
    anyrun-nixos-options.url = "github:n3oney/anyrun-nixos-options";

    millennium = {
      url = "git+https://github.com/SteamClientHomebrew/Millennium?ref=refs/heads/next";
      #url = "git+https://github.com/Enovale/Millennium?ref=refs/heads/next";
    };

    moonlight = {
      url = "github:moonlight-mod/moonlight/develop"; # Add `/develop` to the flake URL to use nightly.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tgirlpkgs = {
      url = "github:tgirlcloud/pkgs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    jdownloader = {
      url = "https://installer.jdownloader.org/JDownloader.jar";
      flake = false;
    };

    qt5ct-kde = {
      url = "https://downloads.sourceforge.net/project/qt5ct/qt5ct-1.9.tar.bz2";
      flake = false;
    };

    qt6ct-kde = {
      type = "github";
      owner = "ilya-fedin";
      repo = "qt6ct";
      flake = false;
    };

    xdg-desktop-portal-wlr = {
      type = "github";
      owner = "emersion";
      repo = "xdg-desktop-portal-wlr";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      tgirlpkgs,
      home-manager,
      rust-overlay,
      nur,
      ...
    }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
        overlays = [
          rust-overlay.overlays.default
        ];
      };
      naersk = pkgs.callPackage inputs.naersk {};
      customPkgs = pkgs.callPackage ./packages { inherit inputs naersk; };
    in
    {
      packages.${pkgs.stdenv.hostPlatform.system} = customPkgs;

      overlays.default =
        final: prev: (pkgs.callPackage ./packages/overlay.nix { inherit final prev inputs; }) // customPkgs;

      # taken and slightly modified from
      # https://github.com/lilyinstarlight/nixos-cosmic/blob/0b0e62252fb3b4e6b0a763190413513be499c026/flake.nix#L81
      apps.${pkgs.stdenv.hostPlatform.system} = with nixpkgs; {
        update = {
          type = "app";
          program = lib.getExe (
            pkgs.writeShellApplication {
              name = "update";

              text = lib.concatStringsSep "\n" (
                lib.mapAttrsToList (
                  name: pkg:
                  if pkg ? updateScript && (lib.isList pkg.updateScript) && (lib.length pkg.updateScript) > 0 then
                    lib.escapeShellArgs (
                      if (lib.match "nix-update|.*/nix-update" (lib.head pkg.updateScript) != null) then
                        [ (lib.getExe pkgs.nix-update) ]
                        ++ (lib.tail pkg.updateScript)
                        ++ [
                          "--flake"
                          "--commit"
                          name
                        ]
                      else
                        pkg.updateScript
                    )
                  else
                    builtins.toString pkg.updateScript or ""
                ) self.packages.${pkgs.stdenv.hostPlatform.system}
              );
            }
          );
        };
      };

      nixosConfigurations.crystalline = nixpkgs.lib.nixosSystem {
        modules = [
          ./globals.nix
          ./qemu_check.nix
          ./configuration.nix
          inputs.gpu-screen-recorder-ui.nixosModules.default
          tgirlpkgs.nixosModules.default
          nur.modules.nixos.default
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "hm-bak";

              sharedModules = [
                inputs.nix-index-database.homeModules.nix-index
                inputs.nur.modules.homeManager.default
                inputs.nixcord.homeModules.nixcord
                inputs.nix-colors.homeManagerModules.default
                inputs.plasma-manager.homeManagerModules.plasma-manager
                inputs.kidex.homeModules.kidex
                inputs.moonlight.homeModules.default
                inputs.tgirlpkgs.homeModules.default
              ];

              users.enova = import ./home/home.nix;
              extraSpecialArgs = { inherit inputs; };
            };
          }
          inputs.nixos-xivlauncher-rb.nixosModules.default
        ];
        specialArgs = { inherit inputs; };
      };
    };
}
