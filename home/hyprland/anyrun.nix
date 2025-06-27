{
  pkgs,
  inputs,
  osConfig,
  ...
}:
{
  programs.anyrun = {
    enable = true;
    config = {
      x = {
        fraction = 0.5;
      };
      y = {
        fraction = 0.0;
      };
      width = {
        absolute = 800;
      };
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "overlay";
      hidePluginInfo = false;
      closeOnClick = true;
      showResultsImmediately = false;
      maxEntries = null;

      plugins =
        with pkgs;
        with inputs.anyrun.packages.${pkgs.system};
        [
          # An array of all the plugins you want, which either can be paths to the .so files, or their packages
          applications
          symbols
          shell
          translate
          rink
          websearch
          kidex
          dictionary
          inputs.anyrun-nixos-options.packages.${pkgs.system}.default
        ];
    };

    # Inline comments are supported for language injection into
    # multi-line strings with Treesitter! (Depends on your editor)
    extraCss = builtins.readFile ./anyrun.css;

    extraConfigFiles."nixos-options.ron".text =
      let
        nixos-options = osConfig.system.build.manual.optionsJSON + "/share/doc/nixos/options.json";
        hm-options =
          inputs.home-manager.packages.${pkgs.system}.docs-json + "/share/doc/home-manager/options.json";
        # merge your options
        options = builtins.toJSON {
          ":nix" = [ nixos-options ];
          ":hm" = [ hm-options ];
          ":nall" = [
            nixos-options
            hm-options
          ];
        };
      in
      ''
        Config(
            // add your option paths
            options: ${options},
            max_entries: Some(5),
         )
      '';
  };
}
