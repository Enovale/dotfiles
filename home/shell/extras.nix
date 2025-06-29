{
  programs.eza = {
    enable = true;
    git = true;
    icons = "auto";
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.nix-index.enable = true;
}