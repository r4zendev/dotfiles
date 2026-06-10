{ pkgs, ... }:

{
  services.xserver.enable = true;
  services.xserver.windowManager.oxwm.enable = true;

  environment.systemPackages = with pkgs; [
    xclip
    maim
  ];
}
