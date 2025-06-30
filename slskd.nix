{
  config,
  pkgs,
  lib,
  ...
}:
{
  # TODO Setup sops-nix
  services.slskd = {
    enable = false;
    domain = null;
    environmentFile = ./slskd.env;

    settings = {
      shares = {
        directories = [];
      };
    };
  };
}
