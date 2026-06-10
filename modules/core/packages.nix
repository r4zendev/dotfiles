{ pkgs, ... }:

{
  environment.variables.EDITOR = "nvim";

  environment.systemPackages = with pkgs; [
    git
    curl
    jq
    btop
    neovim
    kdePackages.dolphin
    wl-clipboard
  ];
}
