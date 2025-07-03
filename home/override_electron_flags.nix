{config, pkgs, lib, ...}:
{
  #home.packages =
  #  (import ../electron_flags.nix {
  #    inherit lib;
  #    packagesToOverride = with pkgs; [ vscodium goofcord signal-desktop ];
  #  }).overriden;
}