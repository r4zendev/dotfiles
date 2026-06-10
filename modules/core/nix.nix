{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.max-jobs = 4;
  nix.settings.cores = 8;
  nix.settings.auto-optimise-store = true;

  nixpkgs.config.allowUnfree = true;

  programs.nix-ld.enable = true;

  programs.nh = {
    enable = true;
    flake = "/home/razen/projects/dotfiles";
    clean.enable = true;
    clean.extraArgs = "--keep 5 --keep-since 4d";
  };
}
