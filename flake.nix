{
  description = "NixOS Configuration Flake";

  inputs = {
    self.submodules = true;

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

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nix-colors.url = "github:misterio77/nix-colors";

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    import-tree.url = "github:vic/import-tree";
    flake-parts.url = "github:hercules-ci/flake-parts";

    kidex.url = "github:Kirottu/kidex";
    anyrun-nixos-options.url = "github:n3oney/anyrun-nixos-options";

    millennium = {
      url = "git+https://github.com/Sk7Str1p3/Millennium";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nur,
      ...
    }:
    {
      nixosConfigurations.crystalline = nixpkgs.lib.nixosSystem {
        modules = [
          ./qemu_check.nix
          ./configuration.nix
          nur.modules.nixos.default
          home-manager.nixosModules.home-manager {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "hm-bak";

                sharedModules = [
                  #inputs.catppuccin.homeModules.catppuccin
                  inputs.nur.modules.homeManager.default
                  inputs.nixcord.homeModules.nixcord
                  inputs.nix-colors.homeManagerModules.default
                  inputs.plasma-manager.homeManagerModules.plasma-manager
                  inputs.kidex.homeModules.kidex
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
