{ config, pkgs, lib, ... }:

{
  # PipeWire and WirePlumber overrides managed via stow:
  #   stow/linux/.config/pipewire/pipewire.conf.d/10-buffer.conf
  #   stow/linux/.config/wireplumber/wireplumber.conf.d/50-alsa.conf
  #   stow/linux/.config/wireplumber/wireplumber.conf.d/51-disable-webcam-mic.conf

  services.playerctld.enable = true;

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  services.cliphist.enable = true;
}
