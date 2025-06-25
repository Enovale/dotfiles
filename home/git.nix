{
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName  = "Enova";
    userEmail = "enovale@proton.me";
    aliases = {
      ci = "commit";
      co = "checkout";
      s = "status";
    };
  };
}