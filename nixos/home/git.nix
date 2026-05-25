{ config, pkgs, ... }:

{
  # Git config managed via stow (stow/common/.gitconfig)
  # Lazygit config via stow (stow/common/.config/lazygit/)
  # GH config via stow (stow/common/.config/gh/)
  home.packages = with pkgs; [
    git
    git-delta
    gh
    lazygit
    jujutsu
  ];
}
