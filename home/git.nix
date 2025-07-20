{ config, ... }:
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Enovale";
    userEmail = "enovale@proton.me";
    aliases = {
      ci = "commit";
      co = "checkout";
      s = "status";
    };
    extraConfig = {
      core = {
        autocrlf = "input";
      };
      init = {
        defaultBranch = "main";
      };
    };
  };
}
