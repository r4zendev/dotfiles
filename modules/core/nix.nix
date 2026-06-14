{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.max-jobs = 4;
  nix.settings.cores = 8;
  nix.settings.auto-optimise-store = true;

  nix.settings.extra-substituters = [ "https://hyprland.cachix.org" ];
  nix.settings.extra-trusted-public-keys = [
    "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
  ];

  nixpkgs.config.allowUnfree = true;

  programs.nix-ld.enable = true;

  programs.nh = {
    enable = true;
    flake = "/home/razen/projects/dotfiles";
    clean.enable = true;
    clean.extraArgs = "--keep 5 --keep-since 4d";
  };
}
