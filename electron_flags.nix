{
  lib,
  packagesToOverride,
  ...
}:
{
  overriden = builtins.map (
    x:
    let
      args = builtins.attrNames x.override.__functionArgs;
      hasCmdArgs = builtins.any (y: y == "commandLineArgs") args;
      isElectron = builtins.any (z: (lib.hasPrefix "electron" z)) args;
    in
    if (hasCmdArgs && isElectron) then
      x.override {
        commandLineArgs = "--password-store=kwallet6";
      }
    else
      x
  ) packagesToOverride;
}
