{ config, ... }:
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = config.home.username;
    userEmail = "enovale@proton.me";
    aliases = {
      ci = "commit";
      co = "checkout";
      s = "status";
    };
  };
}
