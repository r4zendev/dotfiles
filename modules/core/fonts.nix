{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack
    nerd-fonts.symbols-only
    noto-fonts
    dejavu_fonts
    inter
    fira-code
    material-symbols
    monaspace
    noto-fonts-color-emoji
  ];
}
